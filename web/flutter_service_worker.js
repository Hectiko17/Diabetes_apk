"use strict";
const CACHE_NAME = "flutter-app-cache";
const RESOURCES = {
  "index.html": "c20dfda7f4b2b669b2f07fcaa57644d3",
  "/": "c20dfda7f4b2b669b2f07fcaa57644d3",
  "main.dart.js": "bd76bf768bb826daf28a9829a2f8f908",
  "flutter.js": "a8e94ef05df49e0a4eabb771e4900840",
  "icons/Icon-192.png": "4ad6c3f205e37e34318b6f209a1b44b7",
  "icons/Icon-512.png": "96ce1d344e6d21a3b6a02c399a4f0e40",
  "manifest.json": "2b1d37d4c6fa79a7be6a55066348e8d8",
  "assets/AssetManifest.json": "bbf8b2c9256a37d6cf2d1b7e9d4bc74f",
  "assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
  "assets/fonts/MaterialIcons-Regular.otf": "1c9a9d734f2b09a1c32b8a81d776d5d9",
  "assets/NOTICES": "eb7a8a6b9a74ff02b5fa908dd4a97ed1",
};

self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener("activate", (event) => {
  return event.waitUntil(
    (async function () {
      try {
        const contentCache = await caches.open(CACHE_NAME);
        const keys = await contentCache.keys();
        await Promise.all(
          keys.map(async (request) => {
            if (
              !RESOURCES[request.url.substring(self.location.origin.length + 1)]
            ) {
              await contentCache.delete(request);
            }
          })
        );
        return self.clients.claim();
      } catch (err) {
        console.error("Failed to upgrade service worker: " + err);
      }
    })()
  );
});

self.addEventListener("fetch", (event) => {
  if (event.request.method !== "GET") {
    return;
  }
  const key = event.request.url.substring(self.location.origin.length + 1);
  if (!RESOURCES[key]) {
    return;
  }
  event.respondWith(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.match(event.request).then((response) => {
        return (
          response ||
          fetch(event.request).then((response) => {
            cache.put(event.request, response.clone());
            return response;
          })
        );
      });
    })
  );
});
