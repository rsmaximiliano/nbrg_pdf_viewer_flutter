package dev.nbrg.nbrg_pdf_viewer_flutter;

import io.flutter.plugin.common.MethodCall;

class ViewerParams {
    boolean enableDoubletap, swipeHorizontal, enableSwipe;
    int spacing, defaultPage;

    private ViewerParams() {
        enableSwipe = true;
        swipeHorizontal = false;
        enableDoubletap = true;
        spacing = 0;
        defaultPage = 0;
    }

    private ViewerParams(boolean enableDoubletap, boolean swipeHorizontal, boolean enableSwipe, int spacing, int defaultPage) {
        this.enableDoubletap = enableDoubletap;
        this.swipeHorizontal = swipeHorizontal;
        this.enableSwipe = enableSwipe;
        this.spacing = spacing;
        this.defaultPage = defaultPage;
    }

    public static ViewerParams fromCall(MethodCall call) {
        if (call == null) {
            return new ViewerParams();
        }
        boolean enableDoubletap = call.argument("enableDoubletap");
        boolean swipeHorizontal = call.argument("swipeHorizontal");
        boolean enableSwipe = call.argument("enableSwipe");
        int spacing = call.argument("spacing");
        int defaultPage = call.argument("defaultPage");
        return new ViewerParams(enableDoubletap, swipeHorizontal, enableSwipe, spacing, defaultPage);
    }

    public boolean isEnableDoubletap() {
        return enableDoubletap;
    }

    public void setEnableDoubletap(boolean enableDoubletap) {
        this.enableDoubletap = enableDoubletap;
    }

    public boolean isSwipeHorizontal() {
        return swipeHorizontal;
    }

    public void setSwipeHorizontal(boolean swipeHorizontal) {
        this.swipeHorizontal = swipeHorizontal;
    }

    public boolean isEnableSwipe() {
        return enableSwipe;
    }

    public void setEnableSwipe(boolean enableSwipe) {
        this.enableSwipe = enableSwipe;
    }

    public int getSpacing() {
        return spacing;
    }

    public void setSpacing(int spacing) {
        this.spacing = spacing;
    }

    public int getDefaultPage() {
        return defaultPage;
    }

    public void setDefaultPage(int defaultPage) {
        this.defaultPage = defaultPage;
    }
}