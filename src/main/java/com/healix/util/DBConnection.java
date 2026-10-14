package com.healix.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Core Java Pattern: Singleton Pattern + Connection Pooling
 * Manages thread-safe JDBC connections to Supabase PostgreSQL.
 */
public class DBConnection {
    private static DBConnection instance;
    private HikariDataSource dataSource;

    private DBConnection() {
        try {
            Properties props = new Properties();
            try (InputStream input = getClass().getClassLoader().getResourceAsStream("db.properties")) {
                if (input != null) {
                    props.load(input);
                } else {
                    // Fallback configuration
                    props.setProperty("db.url", "jdbc:postgresql://aws-0-ap-southeast-2.pooler.supabase.com:6543/postgres?sslmode=require");
                    props.setProperty("db.user", "postgres.gjvwnabfommajpsgneud");
                    props.setProperty("db.password", "vrvU5vFd6U3MBpwY");
                    props.setProperty("db.driver", "org.postgresql.Driver");
                }
            }

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(props.getProperty("db.url"));
            config.setUsername(props.getProperty("db.user"));
            config.setPassword(props.getProperty("db.password"));
            config.setDriverClassName(props.getProperty("db.driver", "org.postgresql.Driver"));
            config.setMaximumPoolSize(Integer.parseInt(props.getProperty("db.pool.maxSize", "10")));
            config.setMinimumIdle(Integer.parseInt(props.getProperty("db.pool.minIdle", "2")));
            config.setConnectionTimeout(30000);
            config.setIdleTimeout(600000);

            dataSource = new HikariDataSource(config);
            System.out.println("Healix DBConnection: HikariCP pool initialized connected to Supabase PostgreSQL!");
        } catch (Exception e) {
            System.err.println("Healix DBConnection: Initialization failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static synchronized DBConnection getInstance() {
        if (instance == null) {
            instance = new DBConnection();
        }
        return instance;
    }

    public Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("Database connection pool is not initialized.");
        }
        return dataSource.getConnection();
    }

    public void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}
