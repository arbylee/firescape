package org.rscdaemon.server.util;

import org.rscdaemon.server.model.World;

public class Logger {
  /**
   * World instance
   */
  private static final World world = World.getWorld();

  public static void print(Object o, int i) {
    String type = "";
    if (i == 1) {
      type = "[Error] ";
    } else if (i == 2) // Staff Actions
    {
      type = "[Staff] ";
    } else if (i == 3) // Other
    {
      type = "[Other] ";
    } else if (i == 4) // Other
    {
      type = "[Network] ";
    }
    System.out.println(type + o.toString());
    // org.rscdaemon.server.GUI.cout(o.toString(), i);
  }

  public static void connection(Object o) {
    Logger.print(o, 4);
  }

  public static void mod(Object o) {
    Logger.print(o.toString(), 2);
  }

  public static void event(Object o) {

  }

  public static void error(Object o) {
    if (o instanceof Exception) {
      Exception e = (Exception) o;
      e.printStackTrace();
      // org.rscdaemon.server.GUI.cout(e.getMessage(), 1);
      // org.rscdaemon.server.GUI.cout(e.getStackTrace().toString(), 1);
      if (world == null || !world.getServer().isInitialized()) {
        System.exit(1);
      } else {
        // world.getServer().kill();
      }
      return;
    } else if (o instanceof String) {
      System.out.println("[ERROR] " + o);
    }
  }
}
