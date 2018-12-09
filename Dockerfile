from python:3.6

RUN apt-get update
RUN apt-get install --assume-yes cron
RUN apt-get install --assume-yes less
RUN apt-get install --assume-yes curl
RUN apt-get install --assume-yes vim
RUN apt-get install --assume-yes rsyslog

WORKDIR /tools
COPY ./tools /tools

# Install gcloud
# Python 2.7 is due to: https://code.google.com/p/google-cloud-sdk/issues/detail?id=355
ENV CLOUDSDK_PYTHON=/usr/bin/python2.7
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN apt-get install -y -qq --no-install-recommends wget unzip python openssh-client \
  && apt-get clean \
  && cd /usr/local/bin \
  && wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip \
  && google-cloud-sdk/install.sh --usage-reporting=true --disable-installation-options \
  && google-cloud-sdk/bin/gcloud --quiet components update preview \
  && google-cloud-sdk/bin/gcloud --quiet config set component_manager/disable_update_check true \
  && google-cloud-sdk/bin/gcloud --quiet components install kubectl
ENV PATH /usr/local/bin/google-cloud-sdk/bin:$PATH

ENV PYTHONPATH=/utils

CMD /tools/main.sh
