# Define a job called my-service
job "hashiapp-demo" {
    region = "europe"

    # Spread tasks between us-west-1 and us-east-1
    datacenters = ["dc1"]

    # run this with service scheduler
    type = "service"

    # Rolling updates should be sequential
    update {
        stagger = "30s"
        max_parallel = 1
    }

    group "webs" {
        # We want 1 web servers
        count = 1

        # Create a web front end using a docker image
        task "web" {
            driver = "java"

            config {
                jar_path = "local/hashiapp-java-demo-1.0.0.jar"
                args = ["--spring.config.location=${app_install_path}/"]
                jvm_options = ["-Xmx2048m", "-Xms256m"]
            }

            # Specifying an artifact is required with the "java"
            # driver. This is the # mechanism to ship the Jar to be run.
            artifact {
                source = "${app_sb_download_url}"
            }

            service {
                port = "http"
                check {
                    type = "http"
                    path = "health"
                    interval = "10s"
                    timeout = "2s"
                }
            }
            resources {
                network {
                    mbits = 1
                    # Request for a dynamic port
                    port "http" {
                        static = ${app_port}
                    }
                    # Request for a static port
                    port "https" {
                      static = 443
                    }
                }
            }
        }
    }
}