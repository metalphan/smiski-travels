export default {
    async fetch(request, env) {
        const url = new URL(request.url);
        const albumId = url.searchParams.get("album_id");

        if (!albumId) {
            return new Response("Missing album_id query parameter", { status: 400 });
        }

        // Access token stored in environment variable
        const accessToken = env.GOOGLE_ACCESS_TOKEN;

        const googleApiUrl = `https://photoslibrary.googleapis.com/v1/mediaItems:search`;
        const requestBody = JSON.stringify({ albumId });

        // Fetch photos from Google Photos API
        const response = await fetch(googleApiUrl, {
            method: "POST",
            headers: {
                Authorization: `Bearer ${accessToken}`,
                "Content-Type": "application/json",
            },
            body: requestBody,
        });

        if (!response.ok) {
            return new Response(`Error fetching photos: ${response.statusText}`, { status: response.status });
        }

        const data = await response.json();

        // Extract and return photo URLs and metadata
        const photos = data.mediaItems.map((item) => ({
            url: item.baseUrl,
            filename: item.filename,
        }));

        return new Response(JSON.stringify(photos), {
            headers: { "Content-Type": "application/json" },
        });
    },
};
