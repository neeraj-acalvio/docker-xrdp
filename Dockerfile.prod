FROM ubuntu:latest

ARG XRDP_VERSION=0.10.6

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    vim \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Install xrdp build dependencies (script is not bundled in release tarballs)
RUN apt-get update && apt-get install -y --no-install-recommends wget ca-certificates \
    && wget -v "https://raw.githubusercontent.com/neutrinolabs/xrdp/v${XRDP_VERSION}/scripts/install_xrdp_build_dependencies_with_apt.sh" -O /tmp/install_deps.sh \
    && chmod +x /tmp/install_deps.sh \
    && sed -i 's/apt-get upgrade$/apt-get upgrade -y/' /tmp/install_deps.sh \
    && /tmp/install_deps.sh max \
    && rm /tmp/install_deps.sh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Download, build, and install xrdp from source
RUN wget -v "https://github.com/neutrinolabs/xrdp/releases/download/v${XRDP_VERSION}/xrdp-${XRDP_VERSION}.tar.gz" -O /tmp/xrdp.tar.gz \
    && tar -xzf /tmp/xrdp.tar.gz -C /tmp \
    && cd "/tmp/xrdp-${XRDP_VERSION}" \
    && ./configure --with-systemdsystemunitdir=/usr/lib/systemd/system \
    && make -j"$(nproc)" \
    && make install \
    && rm -rf /tmp/xrdp.tar.gz "/tmp/xrdp-${XRDP_VERSION}"

# Symlink binaries and prepare runtime dirs (systemd is not available in containers)
RUN ln -sf /usr/local/sbin/xrdp /usr/sbin/xrdp \
    && ln -sf /usr/local/sbin/xrdp-sesman /usr/sbin/xrdp-sesman \
    && ln -sf /usr/local/sbin/xrdp-keygen /usr/sbin/xrdp-keygen \
    && (getent group xrdp || groupadd -r xrdp) \
    && (getent passwd xrdp || useradd -r -g xrdp -s /sbin/nologin -d /var/run/xrdp xrdp) \
    && install -o root -g xrdp -m 2775 -d /var/run/xrdp \
    && install -o root -g xrdp -m 3777 -d /var/run/xrdp/sockdir

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3389

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]