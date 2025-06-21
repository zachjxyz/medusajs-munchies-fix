import Medusa from "@medusajs/js-sdk";

// Use window.location to determine the backend URL in the browser
export const backendUrl = typeof window !== "undefined" 
  ? `${window.location.protocol}//${window.location.hostname}:9000`
  : "http://localhost:9000";

export const sdk = new Medusa({
  baseUrl: backendUrl,
  auth: {
    type: "session",
  },
});

// useful when you want to call the BE from the console and try things out quickly
if (typeof window !== "undefined") {
  (window as any).__sdk = sdk;
}
