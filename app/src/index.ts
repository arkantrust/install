export default {
  async fetch(req: Request): Promise<Response> {
    const url = new URL(req.url);
    const path = url.pathname.replace(/^\/|\/$/g, ''); // Remove leading/trailing slashes

    const GITHUB_REPO = "https://raw.githubusercontent.com/arkantrust/install/main";
    const scriptUrl = `${GITHUB_REPO}/${path}.sh`;

    try {
      const res = await fetch(scriptUrl);

      if (!res.ok) {
        return new Response(`Script not found: ${path}`, { status: 404 });
      }

      const script = await res.text();
      return new Response(script, {
        headers: { 'Content-Type': 'text/plain' },
      });

    } catch (error) {
      return new Response(`Error fetching script: ${error}`, { status: 500 });
    }
  },
};
