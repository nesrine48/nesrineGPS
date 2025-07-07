console.log("vehicleMap.js chargé 🚗");
let map, marker, carIcon, pathPolyline;
let pendingLat = null, pendingLon = null, pendingPath = null;
let lastLat = null, lastLon = null;

function initializeControlAddIn() {
    if (map) {
        map.remove();
        map = null;
    }

    // Créer une icône de voiture personnalisée
    carIcon = L.icon({
        iconUrl: Microsoft.Dynamics.NAV.GetImageResource('VehicleMapControl/car-red-96x96.png')+ '?v=' + new Date().getTime()
,
        iconSize: [60, 60],
        iconAnchor: [28, 28]
    });
    console.log("✅ Icône voiture chargée :", carIcon.options.iconUrl);

    const mapElement = document.getElementById('map');
    if (!mapElement) {
        console.error("❌ Élément div#map introuvable !");
        return;
    }

  map = L.map(mapElement, {
    maxZoom: 20 ,
    closePopupOnClick: false 
}).setView([36.8065, 10.1815], 18);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '&copy; OpenStreetMap contributors', maxZoom: 20 }).addTo(map);




    // Appliquer les valeurs mises en attente
    if (pendingLat !== null && pendingLon !== null) {
        updateMarker(pendingLat, pendingLon);
        pendingLat = pendingLon = null;
    }

    if (pendingPath !== null) {
        window.SetPath(pendingPath);
        pendingPath = null;
    }

    console.log("✅ Carte initialisée avec succès");
}

function updateMarker(lat, lon) {
    if (!map) {
        console.warn("🕗 Carte non encore disponible");
        return;
    }

    lat = typeof lat === "string" ? parseFloat(lat.replace(',', '.')) : lat;
    lon = typeof lon === "string" ? parseFloat(lon.replace(',', '.')) : lon;

    if (lat === 0 && lon === 0) {
        console.warn("⚠️ Coordonnées (0,0) ignorées");
        return;
    }

    if (isNaN(lat) || isNaN(lon)) {
        console.error("❌ Coordonnées invalides :", lat, lon);
        return;
    }

    lastLat = lat;
    lastLon = lon;

    if (marker) {
        marker.setLatLng([lat, lon]);
    } else {
        marker = L.marker([lat, lon], { icon: carIcon }).addTo(map);
    }

    map.setView([lat, lon], 18);
}

function updatePath(pathPoints) {
    if (!map) return;

    if (pathPolyline) {
        map.removeLayer(pathPolyline);
    }

    pathPolyline = L.polyline(pathPoints, { color: 'blue' }).addTo(map);
}

// Appelée depuis AL
window.SetCoordinates = function (lat, lon) {
    console.log("📍 SetCoordinates reçu :", lat, lon);
    if (!map) {
        pendingLat = lat;
        pendingLon = lon;
        return;
    }
    updateMarker(lat, lon);
};

// Appelée depuis AL pour tracer un chemin
window.SetPath = function (pathText) {
    if (!map) {
        pendingPath = pathText;
        return;
    }

    if (!pathText || pathText.trim() === "") return;

    try {
        const pathPoints = JSON.parse(pathText);
        if (Array.isArray(pathPoints) && pathPoints.length > 0 && Array.isArray(pathPoints[0])) {
            updatePath(pathPoints);
        } else {
            throw new Error("Format invalide");
        }
    } catch (e) {
        console.error("❌ Chemin GPS invalide :", e.message);
    }
};

// Recentrer sur le marqueur
window.Refresh = function () {
    if (map && marker && lastLat !== null && lastLon !== null) {
        map.setView([lastLat, lastLon], 13);
        marker.setLatLng([lastLat, lastLon]);
    }
};

// 🔍 Méthodes personnalisées AL
window.SetZoom = function (level) {
    if (map) map.setZoom(level);
};

window.SetPinLabel = function (text) {
    if (marker) {
        marker.bindPopup(text, { closeButton: false }).openPopup();
        map.closePopupOnClick = false;
    }
};


// Initialisation unique
function ensureMapDivAndInit() {
    document.body.innerHTML = '';

    const oldMap = document.getElementById('map');
    if (oldMap) {
        oldMap.parentNode.removeChild(oldMap);
        console.log("♻️ Ancien div supprimé");
    }

    const container = document.createElement('div');
    container.id = 'map';
    container.style.width = '100%';
    container.style.height = '400px';
    document.body.appendChild(container);
    console.log("🆕 Div map créé");

    initializeControlAddIn();
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", ensureMapDivAndInit);
} else {
    ensureMapDivAndInit();
}
