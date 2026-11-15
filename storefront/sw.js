const CACHE_NAME="shopstyve-pwa-v1";
const SHELL=["./","./index.html","./manifest.webmanifest","./styve-logo.svg","./icons/shopstyve-192.svg","./icons/shopstyve-512.svg"];
self.addEventListener("install",event=>event.waitUntil(caches.open(CACHE_NAME).then(c=>c.addAll(SHELL)).then(()=>self.skipWaiting())));
self.addEventListener("activate",event=>event.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k.startsWith("shopstyve-pwa-")&&k!==CACHE_NAME).map(k=>caches.delete(k)))).then(()=>self.clients.claim())));
self.addEventListener("fetch",event=>{
 const req=event.request;if(req.method!=="GET")return;
 const url=new URL(req.url);if(url.origin!==self.location.origin)return;
 if(url.pathname.includes("/functions/")||url.pathname.includes("/rest/v1/"))return;
 if(req.mode==="navigate"){event.respondWith(fetch(req).then(res=>{if(res.ok)caches.open(CACHE_NAME).then(c=>c.put("./index.html",res.clone()));return res}).catch(async()=>await caches.match("./index.html")||Response.error()));return;}
 event.respondWith(caches.match(req).then(hit=>hit||fetch(req).then(res=>{if(res.ok)caches.open(CACHE_NAME).then(c=>c.put(req,res.clone()));return res})));
});