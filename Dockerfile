FROM python:3.9-bullseye

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Julia installation
# Default values can be overridden at build time
# (ARGS are in lower case to distinguish them from ENV)
# Check https://julialang.org/downloads/
ARG julia_version="1.8.5"


# Julia dependencies
# install Julia packages in /opt/julia instead of ${HOME}
ENV JULIA_DEPOT_PATH=/opt/julia \
  JULIA_PKGDIR=/opt/julia \
  JULIA_VERSION="${julia_version}"

WORKDIR /tmp

# hadolint ignore=SC2046
RUN set -x && \
  julia_arch=$(uname -m) && \
  julia_short_arch="${julia_arch}" && \
  if [ "${julia_short_arch}" == "x86_64" ]; then \
  julia_short_arch="x64"; \
  fi; \
  julia_installer="julia-${JULIA_VERSION}-linux-${julia_arch}.tar.gz" && \
  julia_major_minor=$(echo "${JULIA_VERSION}" | cut -d. -f 1,2) && \
  mkdir "/opt/julia-${JULIA_VERSION}" && \
  wget -q "https://julialang-s3.julialang.org/bin/linux/${julia_short_arch}/${julia_major_minor}/${julia_installer}" && \
  tar xzf "${julia_installer}" -C "/opt/julia-${JULIA_VERSION}" --strip-components=1 && \
  rm "${julia_installer}" && \
  ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia




