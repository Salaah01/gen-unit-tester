#!/usr/bin/bash

# Writes to the remote_host's Dockerfile instructions to install packages.
DOCKERFILE_PATH=$1

read -p "Install python3 (y)? [y/n]: " install
if [[ -z "${install}" || "${install,,}" =~ ^(y)|(yes)$ ]]; then
  echo -e "\n# Python 3" >>$DOCKERFILE_PATH
  echo -e "RUN apt install -y python3.9 \\" >>$DOCKERFILE_PATH
  echo -e "\t&& apt install -y python3.9-dev \\" >>$DOCKERFILE_PATH
  echo -e "\t&& rm /usr/bin/python3 \\" >>$DOCKERFILE_PATH
  echo -e "\t&& ln -s python3.9 /usr/bin/python3 \\" >>$DOCKERFILE_PATH
  echo -e "\t&& apt install -y python3-pip \\" >>$DOCKERFILE_PATH
  echo -e "\t&& pip3 install --upgrade pip \\" >>$DOCKERFILE_PATH
  echo -e "\t&& apt install -y python3.9-venv \\" >>$DOCKERFILE_PATH
  echo -e "\t&& python3 -m pip install --user virtualenv" >>$DOCKERFILE_PATH
fi

# Node
install=""
read -p "Install node (y)? [y/N]: " install
if [[ -z "${install}" || "${install,,}" =~ ^(y)|(yes)$ ]]; then
  echo -e "\n# Node" >>$DOCKERFILE_PATH
  echo -e "RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \\" >>$DOCKERFILE_PATH
  echo -e "\t&& apt install -y nodejs" >>$DOCKERFILE_PATH
fi

# Selenium
install=""
read -p "Install selenium (y) [y/N]: " Install
if [[ -z "${install}" || "${install,,}" =~ ^(y)|(yes)$ ]]; then
  echo -e "\n# Selenium" >>$DOCKERFILE_PATH
  echo -e "RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \\" >>$DOCKERFILE_PATH
  echo -e "\t&& sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \\" >>$DOCKERFILE_PATH
  echo -e "\t&& apt -y update \\" >>$DOCKERFILE_PATH
  echo -e "\t&& apt install -y google-chrome-stable \\" >>$DOCKERFILE_PATH
  echo -e "\t&& apt install -yqq unzip \\" >>$DOCKERFILE_PATH
  echo -e "\t&& wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip \\" >>$DOCKERFILE_PATH
  echo -e "\t&& unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/" >>$DOCKERFILE_PATH
fi
