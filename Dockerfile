FROM grafana/grafana:5.1.5
MAINTAINER  Bruce Kissinger <brucekissinger@deancare.com>

EXPOSE 3000 9191

ARG prometheus_version=2.3.2
ARG prometheus_archive_name=prometheus-$prometheus_version.linux-amd64

USER root
RUN apt-get update                                       && \
    apt-get -y --no-install-recommends install curl wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


#RUN mkdir -p /etc/grafana/dashboards

# prometheus setup

RUN wget -O $prometheus_archive_name.tar.gz https://github.com/prometheus/prometheus/releases/download/v$prometheus_version/$prometheus_archive_name.tar.gz && \
    tar -xf /$prometheus_archive_name.tar.gz                                                               && \
    cp      /$prometheus_archive_name/prometheus        /bin/                                              && \
    cp      /$prometheus_archive_name/promtool          /bin/                                              && \
    cp -a   /$prometheus_archive_name/console_libraries /etc/prometheus/                                   && \
    cp -a   /$prometheus_archive_name/consoles          /etc/prometheus/                                   && \
    rm -rf  /$prometheus_archive_name*

# telemetry setup

COPY servicemesh-telemetry      /servicemesh-telemetry
COPY prometheus.yml         	/etc/prometheus/
COPY datasource.yml		/etc/grafana/provisioning/datasources/datasource.yml
COPY dashboard.yml		/etc/grafana/provisioning/dashboards/dashboard.yml
COPY ServiceMeshDashboard.json 	/var/lib/grafana/dashboards/ServiceMeshDashboard.json

ENTRYPOINT [ "/servicemesh-telemetry" ]
