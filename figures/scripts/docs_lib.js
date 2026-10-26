// Helpers for generating documentation figures with ITK-SNAP GUI scripts.
// Scripts are run by make_figures.sh with the working directory set to this
// folder, so that the docs_lib.js include below resolves (includes are
// resolved relative to the working directory). datadir is the figure work
// directory created by make_data.sh; screenshots go to datadir/shots.

include("Library");

function shotPath(name)
{
    return datadir + "/shots/" + name + ".png";
}

function shot(name, widget)
{
    return takeScreenshot(shotPath(name), widget);
}

function panel(name)
{
    // panel0/1/2 are the slice views (axial, sagittal, coronal by default),
    // panel3D is the 3D view
    return engine.findChild(mainwin, name);
}

function waitForImages()
{
    // Images given on the command line load after the event loop starts
    engine.sleep(5000);
}

function expandPanel(name)
{
    // Show a single view in the main window (toggles back if called again)
    engine.clickChild(panel(name), "btnExpand");
    engine.sleep(1000);
}

// Rows of the (fully expanded) tree of visual elements in the preferences
// dialog, in the order they are created in PreferencesDialog.cxx
var APPEARANCE_ROWS = [
    "Slice Views", "Slice Views/Background", "Slice Views/Crosshair",
    "Slice Views/Segmentation bounds", "Slice Views/Rulers",
    "Slice Views/Anatomic Markers", "Slice Views/ROI Edges",
    "Slice Views/ROI Edges (selected)", "Slice Views/Paintbrush",
    "Slice Views/Deformation Grid",
    "3D View", "3D View/Background", "3D View/Crosshair", "3D View/Mesh Outline",
    "Zoom Thumbnail", "Zoom Thumbnail/Thumbnail",
    "Zoom Thumbnail/Current Viewport Outline", "Zoom Thumbnail/Crosshair"];

function selectAppearanceElement(prefs, element)
{
    var row = APPEARANCE_ROWS.indexOf(element);
    if (row < 0)
        engine.testFailed("unknown appearance element " + element);
    var tree = engine.findChild(prefs, "treeVisualElements");
    engine.callMethod(tree, "expandAll", [], true);
    engine.postKeyEvent(tree, "Home");
    for (var i = 0; i < row; i++)
        engine.postKeyEvent(tree, "Down");
    engine.sleep(500);
}

function setAppearance(settings)
{
    // Change visual elements in the preferences dialog. Preferences changed
    // while testing are not saved, so this does not affect the user's setup.
    // settings is a list of [element, visible, color] entries, where element
    // is one of APPEARANCE_ROWS and color (e.g. "#ffffff") may be null.
    engine.trigger("actionPreferences");
    engine.sleep(1000);
    var prefs = engine.findChild(mainwin, "PreferencesDialog");
    engine.invoke(prefs, "set_page_to_appearance");
    engine.sleep(500);
    for (var i = 0; i < settings.length; i++) {
        var s = settings[i];
        selectAppearanceElement(prefs, s[0]);
        var chk = engine.findChild(prefs, "chkElementVisible");
        if (engine.getProperty(chk, "checked") != s[1])
            engine.click(chk, true);
        if (s[2] !== null && s[2] !== undefined)
            engine.setChildProperty(prefs, "btnElementColor", "value", s[2]);
        engine.sleep(300);
    }
    engine.invoke(prefs, "accept");
    engine.sleep(1000);
}

function updateMesh()
{
    var btn = engine.findChild(panel("panel3D"), "btnUpdateMesh");
    if (engine.getProperty(btn, "enabled"))
        engine.click(btn);
    engine.sleep(5000);
}

function loadCamera(file)
{
    engine.trigger("actionImport_Viewpoint", panel("panel3D"));
    engine.sleep(1500);
    var dlg = engine.findWidget("dlgSimpleFile");
    engine.setChildProperty(dlg, "inFilename", "text", file);
    engine.invoke(dlg, "accept");
    engine.sleep(3000);
}
