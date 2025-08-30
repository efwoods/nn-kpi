# Dockerfile
FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y supervisor nginx wget && \
    rm -rf /var/lib/apt/lists/*

# Prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.53.0/prometheus-2.53.0.linux-amd64.tar.gz && \
    tar xvfz prometheus-2.53.0.linux-amd64.tar.gz && \
    mv prometheus-2.53.0.linux-amd64/prometheus /usr/local/bin/ && \
    rm -rf prometheus-2.53.0.linux-amd64*

# Grafana
RUN wget https://dl.grafana.com/oss/release/grafana-11.1.0.linux-amd64.tar.gz && \
    tar xvfz grafana-11.1.0.linux-amd64.tar.gz && \
    mv grafana-v11.1.0 /usr/local/grafana && \
    rm grafana-11.1.0.linux-amd64.tar.gz

# Copy configs and dashboards into the image
COPY prometheus.yml /etc/prometheus/prometheus.yml
COPY grafana.ini /usr/local/grafana/conf/custom.ini
COPY grafana/provisioning /usr/local/grafana/conf/provisioning
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
