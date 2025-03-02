class FTileProviders {
  static const String google =
          "https://mt1.google.com/vt/lyrs=r&x={x}&y={y}&z={z}",
      googleSatellite =
          "https://www.google.cn/maps/vt?lyrs=s@189&gl=cn&x={x}&y={y}&z={z}",
      googleHybrid = "https://mt{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}",
      googleTerrain =
          "https://mt0.google.com/vt/lyrs=t&hl=en&x={x}&y={y}&z={z}",
      osm = "httpss://{s}.tile.osm.org/{z}/{x}/{y}.png",
      osmHot = "https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
      osmFr = "https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png",
      cartoMapPositron =
          "https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
      cartoMapDark = "https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png",
      stamenTerrain = "http://a.tile.stamen.com/terrain/{z}/{x}/{y}.png",
      stamenToner = "http://tile.stamen.com/toner/{z}/{x}/{y}.png",
      stamenWater = "http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg",
      esriSatellite =
          "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
      esriStreets =
          "https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}",
      esriTopo =
          "https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}";
}
