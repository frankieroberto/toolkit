module ApplicationHelper
  def cancel_link(url = {action: :index})
    content_tag("li", class: "cancel") do
      link_to t("cancel"), url
    end
  end

  def basic_map(&block)
    projection = OpenLayers::Projection.new("EPSG:4326")
    googleproj = OpenLayers::Projection.new("EPSG:900913")
    @map = MapLayers::Map.new("map", {theme: "/openlayers/theme/default/style.css", projection: googleproj, displayProjection: projection}) do |map, page|
      page << map.add_layer(MapLayers::OSM_MAPNIK)
      page << map.add_control(OpenLayers::Control::LayerSwitcher.new)

      format = MapLayers::JsVar.new("format")
      page.assign(format, OpenLayers::Format::GeoJSON.new(internalProjection: googleproj, externalProjection: projection))

      vectorlayer = MapLayers::JsVar.new("vectorlayer")
      page.assign(vectorlayer, OpenLayers::Layer::Vector.new("Vectors", projection: projection))
      page << map.add_layer(vectorlayer)
      yield(map, page) if block_given?
    end
  end
end
