FROM google/cloud-sdk:321.0.0-slim

ARG GCP_PROJECT
ARG SERVICE_ACCOUNT
ARG USER=sa-user

RUN apt-get install -y --no-install-recommends \
    vim \
	&& rm -rf /var/lib/apt/lists/*

# create and switch to a normal user
RUN useradd -ms /bin/bash $USER
USER $USER
WORKDIR /home/$USER

# [REQUIRE] prepare a secret key file
COPY sa-secret-key.json $PWD

# [REQUIRE] set the ARG
RUN gcloud auth activate-service-account $SERVICE_ACCOUNT \
        --key-file=$PWD/sa-secret-key.json \
        --project=$GCP_PROJECT && \
    rm $PWD/sa-secret-key.json