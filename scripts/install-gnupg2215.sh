#!/usr/bin/env bash
# =============================================================================
# Title:                    install-gnupg2215.sh
# Description:              POSIX shell script to build and install 
#                           GnuPG 2.2.15 from source
# Author:                   Peter J. Mello
# Date:                     2019-06-04
# Version:                  1.6.1
# Usage:                    [sudo] bash install-gnupg2215.sh
# Notes:                    Developed and tested on Kubuntu 19.04, intended for
#                           use on Ubuntu and its derivatives > version 18.04
# Bash Version:             5.0.3
# SPDX-License-Identifier:  Apache-2.0
# =============================================================================
# Copyright 2019 Peter J. Mello
#
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License.
# =============================================================================

# Basic shell built-ins to promote safe operation
set -eu -o pipefail
shopt -qs failglob

aptitude update ; aptitude install -y dh-autoreconf

# Export environment variable to keep all build processes using bash shell
typeset -x CONFIG_SHELL=$(command -v bash)

# Stash component versions and script shortlink in variables for easy updating
GNUPG_VER=2.3.4
LIBGPG_ERROR_VER=1.44
LIBGCRYPT_VER=1.9.4
LIBKSBA_VER=1.6.0
LIBASSUAN_VER=2.5.5
NTBTLS_VER=0.3.0
NPTH_VER=1.6
PINENTRY_VER=1.2.0
GPGME_VER=1.17.0
GPA_VER=0.10.0

# Start the process with a public service announcement
echo "The author of this script encourages everyone to learn and adopt
good information security habits. As John Perry Barlow once said,

  --\"Relying on the government to protect your privacy is like
      asking a peeping tom to install your window blinds.\"

╭───────────╮    pub rsa2048/AC77588D3F3BCA1E 2017-01-04
│╲  ◯───╥  ╱│    Peter J. Mello <admin at petermello.net>
│╱‵───────′╲│    Sending e-mail without using public key encryption is
╰───────────╯     like sending a letter without sealing the envelope."


# Ensure all necessary dependencies are present on the system
echo "Updating package lists and installing any missing dependencies..."
aptitude install -y bzip2 make gettext texinfo gnutls-bin libgnutls28-dev build-essential \
libbz2-dev zlib1g-dev libncurses5-dev libsqlite3-dev libldap2-dev libsecret-1-dev

# Create folder for build files
echo "Creating working directory at '/var/tmp/gnupg2' for build processes..."
mkdir -p /var/tmp/gnupg2 || echo "Unable to create directory in /var/tmp"
cd /var/tmp/gnupg2 || exit 1

#Build and install libgpg-error
echo "Building and installing libgpg-error..."
wget -c https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-${LIBGPG_ERROR_VER}.tar.bz2
tar xjof libgpg-error-${LIBGPG_ERROR_VER}.tar.bz2
cd libgpg-error-${LIBGPG_ERROR_VER} || exit 1
autoreconf -fi 2>/dev/null
./configure
make -s
make check
make install
cd ..

# Call library linker to scan library directories so newly installed files are available
echo "Calling ldconfig to scan library install locations & update system shared library linker."
ldconfig

# Build and install libgcrypt
echo "Building and installing libgcrypt..."
wget -c https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-${LIBGCRYPT_VER}.tar.bz2
tar xjof libgcrypt-${LIBGCRYPT_VER}.tar.bz2
cd libgcrypt-${LIBGCRYPT_VER} || exit 1
autoreconf -fi 2>/dev/null
./configure --enable-m-guard --with-capabilities
make -s
make check
make install
cd ..

# Call library linker to scan library directories so newly installed files are available
echo "Calling ldconfig to scan library install locations & update system shared library linker."
ldconfig

# Build and install libksba
echo "Building and installing libksba..."
wget -c https://gnupg.org/ftp/gcrypt/libksba/libksba-${LIBKSBA_VER}.tar.bz2
tar xjof libksba-${LIBKSBA_VER}.tar.bz2
cd libksba-${LIBKSBA_VER} || exit 1
autoreconf -fi 2>/dev/null
./configure
make -s
make check
make install
cd ..

# Call library linker to scan library directories so newly installed files are available
echo "Calling ldconfig to scan library install locations & update system shared library linker."
ldconfig

# Build and install libassuan
echo "Building and installing libassuan..."
wget -c https://gnupg.org/ftp/gcrypt/libassuan/libassuan-${LIBASSUAN_VER}.tar.bz2
tar xjof libassuan-${LIBASSUAN_VER}.tar.bz2
cd libassuan-${LIBASSUAN_VER} || exit 1
autoreconf -fi 2>/dev/null
./configure
make -s
make check
make install
cd ..

# Call library linker to scan library directories so newly installed files are available
echo "Calling ldconfig to scan library install locations & update system shared library linker."
ldconfig

# Build and install ntbTLS
echo "Building and installing ntbtls..."
wget -c https://gnupg.org/ftp/gcrypt/ntbtls/ntbtls-${NTBTLS_VER}.tar.bz2
tar xjof ntbtls-${NTBTLS_VER}.tar.bz2
cd ntbtls-${NTBTLS_VER} || exit 1
autoreconf -fi 2>/dev/null
./configure
make -s
make install
cd ..

# Call library linker to scan library directories so newly installed files are available
echo "Calling ldconfig to scan library install locations & update system shared library linker."
ldconfig

# Build and install nPth
echo "Building and installing npth..."
wget -c https://gnupg.org/ftp/gcrypt/npth/npth-${NPTH_VER}.tar.bz2
tar xjof npth-${NPTH_VER}.tar.bz2
cd npth-${NPTH_VER} || exit 1
autoreconf -fi 2>/dev/null
./configure
make -s
make check
make install
cd ..

# Call library linker to scan library directories so newly installed files are available
echo "Calling ldconfig to scan library install locations & update system shared library linker."
ldconfig

# Build and install Pinentry
echo "Building and installing pinentry..."
wget -c https://gnupg.org/ftp/gcrypt/pinentry/pinentry-${PINENTRY_VER}.tar.bz2
tar xjof pinentry-${PINENTRY_VER}.tar.bz2
cd pinentry-${PINENTRY_VER} || exit 1
autoreconf -fi 2>/dev/null
./configure --enable-libsecret --enable-pinentry-tty
make -s
make install
cd ..

# Call library linker to scan library directories so newly installed files are available
echo "Calling ldconfig to scan library install locations & update system shared library linker."
ldconfig

# Build and install GPGME
echo "Building and installing gpgme..."
wget -c https://gnupg.org/ftp/gcrypt/gpgme/gpgme-${GPGME_VER}.tar.bz2
tar xjof gpgme-${GPGME_VER}.tar.bz2
cd gpgme-${GPGME_VER} || exit 1
autoreconf -fi 2>/dev/null
./configure
make -s
make check
make install
cd ..

# Call library linker to scan library directories so newly installed files are available
echo "Calling ldconfig to scan library install locations & update system shared library linker."
ldconfig

# Build and install GPA
#echo "Building and installing gpa..."
#wget -c https://gnupg.org/ftp/gcrypt/gpa/gpa-${GPA_VER}.tar.bz2
#tar xjof gpa-${GPA_VER}.tar.bz2
#cd gpa-${GPA_VER} || exit 1
#autoreconf -fi 2>/dev/null
#./configure
#make -s
#make install
#cd ..

# Call library linker to scan library directories so newly installed files are available
echo "Calling ldconfig to scan library install locations & update system shared library linker."
ldconfig

# Build and install GnuPG
echo "Building and installing GnuPG main package..."
wget -c https://gnupg.org/ftp/gcrypt/gnupg/gnupg-${GNUPG_VER}.tar.bz2
tar xjof gnupg-${GNUPG_VER}.tar.bz2
cd gnupg-${GNUPG_VER} || exit 1
autoreconf -fi 2>/dev/null
./configure --sysconfdir=/etc --localstatedir=/var --runstatedir=/run \
--enable-g13 --enable-symcryptrun --enable-large-secmem --with-capabilities
make -s
make check
make install

# Call library linker to scan library directories so newly installed files are available
echo "Calling ldconfig to scan library install locations & update system shared library linker."
ldconfig

# Inform user of the success of all processes
echo "Successfully built and installed GnuPG ${GNUPG_VER} to /usr/local"
exit 0
