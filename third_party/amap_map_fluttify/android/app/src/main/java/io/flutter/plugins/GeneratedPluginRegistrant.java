package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import me.yohom.amap_core_fluttify.AmapCoreFluttifyPlugin;
import me.yohom.core_location_fluttify.CoreLocationFluttifyPlugin;
import me.yohom.foundation_fluttify.FoundationFluttifyPlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;
import me.yohom.amap_map_fluttify.AmapMapFluttifyPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AmapCoreFluttifyPlugin.registerWith(registry.registrarFor("me.yohom.amap_core_fluttify.AmapCoreFluttifyPlugin"));
    CoreLocationFluttifyPlugin.registerWith(registry.registrarFor("me.yohom.core_location_fluttify.CoreLocationFluttifyPlugin"));
    FoundationFluttifyPlugin.registerWith(registry.registrarFor("me.yohom.foundation_fluttify.FoundationFluttifyPlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
    AmapMapFluttifyPlugin.registerWith(registry.registrarFor("me.yohom.amap_map_fluttify.AmapMapFluttifyPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
