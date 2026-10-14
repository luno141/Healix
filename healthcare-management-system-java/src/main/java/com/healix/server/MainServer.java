package com.healix.server;

import org.apache.catalina.Context;
import org.apache.catalina.LifecycleException;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;
import org.apache.jasper.servlet.JasperInitializer;

import java.io.File;

/**
 * Embedded Tomcat server launcher for the Healix Healthcare Management System.
 */
public class MainServer {

    private static final int DEFAULT_PORT = 8080;

    public static void main(String[] args) throws Exception {
        int port = DEFAULT_PORT;
        String portEnv = System.getenv("PORT");
        if (portEnv != null && !portEnv.trim().isEmpty()) {
            try {
                port = Integer.parseInt(portEnv.trim());
            } catch (NumberFormatException ignored) {}
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);

        // Explicitly create default connector
        tomcat.getConnector();

        // Configure base directory for Tomcat work files
        File baseDir = new File("build/tomcat");
        if (!baseDir.exists()) {
            baseDir.mkdirs();
        }
        tomcat.setBaseDir(baseDir.getAbsolutePath());

        // Configure web application directory
        File webappDir = new File("src/main/webapp");
        if (!webappDir.exists()) {
            webappDir.mkdirs();
        }

        // Add webapp context
        Context ctx = tomcat.addWebapp("", webappDir.getAbsolutePath());

        // Enable JSP support via Jasper initializer
        ctx.addServletContainerInitializer(new JasperInitializer(), null);

        // Add compiled classes directory as a WebResourceSet so servlet annotations (@WebServlet, @WebFilter) are scanned
        File classesFolder = new File("build/classes/java/main");
        if (!classesFolder.exists()) {
            File mavenClasses = new File("target/classes");
            if (mavenClasses.exists()) {
                classesFolder = mavenClasses;
            } else {
                classesFolder.mkdirs();
            }
        }
        String classesDir = classesFolder.getAbsolutePath();

        WebResourceRoot resources = new StandardRoot(ctx);
        resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes", classesDir, "/"));
        ctx.setResources(resources);

        // Register shutdown hook for graceful termination
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            System.out.println("\n[Healix] Shutting down Tomcat server...");
            try {
                tomcat.stop();
                tomcat.destroy();
                System.out.println("[Healix] Server stopped gracefully.");
            } catch (LifecycleException e) {
                System.err.println("[Healix] Error while stopping Tomcat server: " + e.getMessage());
            }
        }));

        // Start embedded Tomcat
        tomcat.start();

        // Print startup banner
        printBanner(port);

        // Await shutdown
        tomcat.getServer().await();
    }

    private static void printBanner(int port) {
        String banner = """
        ============================================================================
          _   _             _ _      
         | | | | ___   __ _| (_)__  __
         | |_| |/ _ \\ / _` | | \\ \\/ /
         |  _  |  __/| (_| | | |>  < 
         |_| |_|\\___| \\__,_|_|_/_/\\_\\
         
          Healix Healthcare Management System
          Server started successfully!
          Application URL : http://localhost:%d/
          Environment     : Embedded Apache Tomcat 10.1.24 (Java 21)
          Status          : RUNNING
          Press Ctrl+C to terminate the server.
        ============================================================================
        """.formatted(port);
        System.out.println(banner);
    }
}
