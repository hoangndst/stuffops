FROM docker:dind
ENV TARGETARCH="linux-musl-x64"

# Another option:
# FROM arm64v8/alpine
# ENV TARGETARCH="linux-musl-arm64"

RUN apk update && \
  apk upgrade && \
  apk add bash curl gcc git icu-libs jq musl-dev python3-dev libffi-dev openssl-dev cargo make
  
# Install Python 3.13 and pip
RUN apk add --no-cache python3=3.12.10-r1 py3-pip 

# Install Azure CLI
# RUN pip install --upgrade pip
# RUN pip install azure-cli
# Install Azure CLI in a virtual environment (recommended for Alpine)
RUN python3 -m venv /opt/azcli-venv && \
    /opt/azcli-venv/bin/pip install --upgrade pip && \
    /opt/azcli-venv/bin/pip install azure-cli

ENV PATH="/opt/azcli-venv/bin:$PATH"

# Install uv
RUN apk add --no-cache uv

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

RUN adduser -D agent
RUN chown agent ./
USER agent
# Another option is to run the agent as root.
ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./start.sh" ]
