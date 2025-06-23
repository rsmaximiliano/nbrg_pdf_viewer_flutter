
package dev.nbrg.nbrg_pdf_viewer_flutter;

import android.app.Activity;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.github.barteksc.pdfviewer.PDFView;

import java.io.File;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * NbrgPdfViewerFlutterManager
 */
class NbrgPdfViewerFlutterManager {

    boolean closed = false;
    PDFView pdfView;
    Activity activity;

    NbrgPdfViewerFlutterManager (final Activity activity) {
        this.pdfView = new PDFView(activity, null);
        this.activity = activity;
    }

    void openPDF(String path) {
        File file = new File(path);
        pdfView.fromFile(file)
                .enableSwipe(true)
                .swipeHorizontal(false)
                .enableDoubletap(true)
                .spacing(30)
                .defaultPage(0)
                .load();
    }

    void openPDF(String path, ViewerParams viewerParams) {
        File file = new File(path);
        if(viewerParams == null){
            pdfView.fromFile(file)
                .enableSwipe(true)
                .swipeHorizontal(false)
                .enableDoubletap(true)
                .spacing(30)
                .defaultPage(0)
                .load();
        } else {
            pdfView.fromFile(file)
                .enableSwipe(viewerParams.enableSwipe)
                .swipeHorizontal(viewerParams.swipeHorizontal)
                .enableDoubletap(viewerParams.enableDoubletap)
                .spacing(viewerParams.spacing)
                .defaultPage(viewerParams.defaultPage)
                .load();
        }
    }

    void resize(FrameLayout.LayoutParams params) {
        pdfView.setLayoutParams(params);
    }

    void close(MethodCall call, MethodChannel.Result result) {
        if (pdfView != null) {
            ViewGroup vg = (ViewGroup) (pdfView.getParent());
            vg.removeView(pdfView);
        }
        pdfView = null;
        if (result != null) {
            result.success(null);
        }

        closed = true;
        NbrgPdfViewerFlutterPlugin.channel.invokeMethod("onDestroy", null);
    }

    void close() {
        close(null, null);
    }
}