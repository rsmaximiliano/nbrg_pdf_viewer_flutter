package dev.nbrg.nbrg_pdf_viewer_flutter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Point;
import android.view.Display;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class NbrgPdfViewerFlutterPlugin implements FlutterPlugin, ActivityAware, PluginRegistry.ActivityResultListener, MethodChannel.MethodCallHandler {
    static MethodChannel channel;
    private Activity activity;
    private NbrgPdfViewerFlutterManager nbrgPdfViewerFlutterManager;
    static private BinaryMessenger binaryMessenger;

    // Empty constructor for the Android Embedding Version 2.
    public NbrgPdfViewerFlutterPlugin() {
    }

    /// This method registers the plugin with an activity.
    private void registerWithActivity(ActivityPluginBinding activityPluginBinding, BinaryMessenger messenger) {
        activity = activityPluginBinding.getActivity();
        channel = new MethodChannel(messenger, "nbrg_pdf_viewer_flutter");
        activityPluginBinding.addActivityResultListener(this);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "launch":
                openPDF(call, result);
                break;
            case "resize":
                resize(call, result);
                break;
            case "close":
                close(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void openPDF(MethodCall call, MethodChannel.Result result) {
        String path = call.argument("path");
        if (nbrgPdfViewerFlutterManager == null || nbrgPdfViewerFlutterManager.closed) {
            nbrgPdfViewerFlutterManager = new NbrgPdfViewerFlutterManager(activity);
        }
        FrameLayout.LayoutParams params = buildLayoutParams(call);
        activity.addContentView(nbrgPdfViewerFlutterManager.pdfView, params);
        ViewerParams viewerParams = ViewerParams.fromCall(call);
        nbrgPdfViewerFlutterManager.openPDF(path, viewerParams);
        result.success(null);
    }

    private void resize(MethodCall call, final MethodChannel.Result result) {
        if (nbrgPdfViewerFlutterManager != null) {
            FrameLayout.LayoutParams params = buildLayoutParams(call);
            nbrgPdfViewerFlutterManager.resize(params);
        }
        result.success(null);
    }

    private void close(MethodCall call, MethodChannel.Result result) {
        if (nbrgPdfViewerFlutterManager != null) {
            nbrgPdfViewerFlutterManager.close(call, result);
            nbrgPdfViewerFlutterManager = null;
        }
    }

    private FrameLayout.LayoutParams buildLayoutParams(MethodCall call) {
        Map<String, Number> rc = call.argument("rect");
        FrameLayout.LayoutParams params;
        if (rc != null) {
            params = new FrameLayout.LayoutParams(dp2px(activity, rc.get("width").intValue()), dp2px(activity, rc.get("height").intValue()));
            params.setMargins(dp2px(activity, rc.get("left").intValue()), dp2px(activity, rc.get("top").intValue()), 0, 0);
        } else {
            Display display = activity.getWindowManager().getDefaultDisplay();
            Point size = new Point();
            display.getSize(size);
            int width = size.x;
            int height = size.y;
            params = new FrameLayout.LayoutParams(width, height);
        }
        return params;
    }

    private int dp2px(Context context, float dp) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dp * scale + 0.5f);
    }

    @Override
    public boolean onActivityResult(int i, int i1, Intent intent) {
        return nbrgPdfViewerFlutterManager != null;
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        binaryMessenger = flutterPluginBinding.getBinaryMessenger();
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding flutterPluginBinding) {
        binaryMessenger = null;
        activity = null;
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
        registerWithActivity(activityPluginBinding, binaryMessenger);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.activity = null;
//        deregisterFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
        registerWithActivity(activityPluginBinding, binaryMessenger);
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
        nbrgPdfViewerFlutterManager.close();
//        deregisterFromActivity();
    }
}
