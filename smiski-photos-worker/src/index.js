export default {
    async fetch(request, env) {
        try {
            const url = new URL(request.url);
            const albumId = url.searchParams.get("album_id");

            // Debug: Log the received album ID
            console.log("Received album ID:", albumId);

            if (!albumId) {
                console.error("Error: Missing album_id query parameter");
                return new Response("Missing album_id query parameter", { status: 400 });
            }

            // Access token stored in environment variable
            const accessToken = env.GOOGLE_ACCESS_TOKEN;

            // Debug: Check if access token exists
            if (!accessToken) {
                console.error("Error: Access token is missing");
                return new Response("Internal server error: Access token is missing", { status: 500 });
            }
			// Debug: Log the access token
			console.log("Access Token (from env):", env.GOOGLE_ACCESS_TOKEN);
			if (!env.GOOGLE_ACCESS_TOKEN) {
				console.error("Access token is missing in the environment variables");
			}


            const googleApiUrl = `https://photoslibrary.googleapis.com/v1/mediaItems:search`;
            const requestBody = JSON.stringify({ albumId });

            console.log("Sending request to Google Photos API with body:", requestBody);

            // Fetch photos from Google Photos API
            const response = await fetch(googleApiUrl, {
                method: "POST",
                headers: {
                    Authorization: `Bearer ${accessToken}`,
                    "Content-Type": "application/json",
                },
                body: requestBody,
            });

            // Debug: Log the API response status
            console.log("Google Photos API response status:", response.status);

            if (!response.ok) {
                console.error(`Error fetching photos: ${response.statusText}`);
                return new Response(`Error fetching photos: ${response.statusText}`, { status: response.status });
            }

            const data = await response.json();

            // Debug: Log the API response data
            console.log("Google Photos API response data:", JSON.stringify(data, null, 2));

            // Extract and return photo URLs and metadata
            if (!data.mediaItems || data.mediaItems.length === 0) {
                console.warn("No photos found in the album");
                return new Response("No photos found in the album", { status: 404 });
            }

            const photos = data.mediaItems.map((item) => ({
                url: item.baseUrl,
                filename: item.filename,
            }));

            console.log("Extracted photo data:", JSON.stringify(photos, null, 2));

            return new Response(JSON.stringify(photos), {
                headers: { "Content-Type": "application/json" },
            });
        } catch (error) {
            console.error("Unexpected error:", error);
            return new Response("Internal server error", { status: 500 });
        }
    },
};
