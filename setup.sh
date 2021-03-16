#!/bin/bash

BASE_DIR=$(dirname $BASH_SOURCE[0])
DOCKERFILE_PATH="${BASE_DIR}/remote_host/Dockerfile"

# Make a copy of the docker-compose base file.
if [[ -f $DOCKERFILE_PATH ]]; then
  echo "Remote host Dockerfile already exists, proceeding will override the file."
  read -p "Do you want to continue? (y/N): " proceed
  if [[ "${proceed,,}" != 'y' ]]; then
    echo 'Exiting setup.'
    exit 1
  fi
fi

cp ./remote_host/base_dockerfile $DOCKERFILE_PATH

# Git setup.
read -p "Git email: " git_email
read -p "Git name: " git_password
read -p "Git SSH secret key path (leave empty to skip): " git_ssh_pk

echo -e "\nRUN git config --global user.email \"${git_email}\" \\" >>$DOCKERFILE_PATH
echo -e "\t&& git config --global user.name \"${git_password}\"" >>$DOCKERFILE_PATH

# If the git SSH secret key path has been set, then copy the file along
# with the corresponding public key into the secrets directory and write
# instruction on the Dockerfile add the SSH keys.
if [[ ! -z "${git_ssh_pk}" ]]; then
  ssh_pk_filename=$(basename $git_ssh_pk)
  
  cp "${git_ssh_pk}" "${BASH_DIR}/remote_host/secrets/."
  cp "${git_ssh_pk}.pub" "${BASH_DIR}/remote_host/secrets/."
  
  echo -e "COPY ./secrets/${ssh_pk_filename} /home/remote_user/.ssh/${ssh_pk_filename}"
  echo -e "COPY ./secrets/${ssh_pk_filename}.pub /home/remote_user/.ssh/${ssh_pk_filename}.pub"
  
  echo -e "RUN eval \$(ssh-agent -s)\n">>$DOCKERFILE_PATH
  echo -e "\tssh-add /home/remote_user/.ssh/${ssh_pk_filename}" 
fi

# Setting up secret keys
mkdir -p -m700 remote_host/secrets

# Creates an SSH key that can be used to SSH into the remote_user for jenkins.
gen_ssh_key=1
if [[ ! -z "${BASE_DIR}/remote_host/secrets/remote-key-rsa" ]]; then
  read -p 'SSH key for jenkins to SSH into remote-host exists, recreate key (y)? [y/N]' regen_ssh_key
  if [[ ! "${regen_ssh_key,,}" =~ ^(y)|(yes)$ ]]; then   
    gen_ssh_key=0
  fi
fi

if [[ $gen_ssh_key -eq 1 ]]; then
  ssh-keygen -t rsa -f "${BASE_DIR}/remote_host/secrets/remote-key-rsa" -m PEM
  chmod 600 "${BASE_DIR}/remote_host/secrets/remote-key-rsa"
fi

# Remote user password
read -p "Set password for remote_user: " password
if [[ -z "${password}" ]]; then
  echo -e "\033[0;31mRemote user password was not set, exiting...\033[0m"
  exit 2
fi
echo "${password}" >"${BASE_DIR}/remote_host/secrets/.password"
chmod 600 "${BASE_DIR}/remote_host/secrets/.password"

# Install additional packages.
bash "${BASE_DIR}/setup_pkg_installs.sh" $DOCKERFILE_PATH
