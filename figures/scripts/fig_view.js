// Generic documentation figure. make_figures.sh writes a wrapper script that
// defines the object 'fig' and then includes this file. Fields of 'fig':
//   name     output file name (without .png)
//   cursor   [x,y,z] voxel position of the cursor (1-based, as in the GUI)
//   expand   panel to show by itself: "panel0".."panel2" or "panel3D"
//   tile     true to show image layers side by side (tiled layout)
//   zoom     zoom factor in screen pixels per mm
//   noseg    true to hide the segmentation
//   mesh     true to render 3D meshes
//   camera   true to render 3D meshes and load cameras/<name>.json
//   background  3D view background color (default "#ffffff")
//   target   "main" (whole window, default) or "view" (rendering only)
include("docs_lib.js");

waitForImages();

if (fig.camera) {
    setAppearance([["3D View/Crosshair", false, null],
                   ["3D View/Background", true, fig.background || "#ffffff"]]);
}

// Figures showing just a slice view are drawn without GUI decorations
if (fig.target == "view" && fig.expand != "panel3D") {
    setAppearance([["Slice Views/Crosshair", false, null],
                   ["Zoom Thumbnail/Thumbnail", false, null]]);
}

if (fig.cursor)
    setCursor(fig.cursor[0], fig.cursor[1], fig.cursor[2]);

if (fig.tile)
    engine.trigger("actionToggleLayerLayout");

if (fig.expand)
    expandPanel(fig.expand);

if (fig.zoom) {
    var zi = engine.findChild(mainwin, "pageZoomInspector");
    engine.setChildProperty(zi, "inZoom", "value", fig.zoom);
    engine.sleep(500);
}

if (fig.cursor)
    engine.trigger("actionCenter_on_Cursor");

if (fig.noseg)
    engine.trigger("actionSegmentationToggle");

if (fig.mesh || fig.camera)
    updateMesh();

if (fig.camera) {
    loadCamera(datadir + "/cameras/" + fig.name + ".json");
}

var widget = mainwin;
if (fig.target == "view") {
    widget = (fig.expand == "panel3D")
        ? engine.findChild(panel("panel3D"), "view3d")
        : engine.findChild(panel(fig.expand), "sliceViewNew");
}
shot(fig.name, widget);
