timedatectl set-timezone $TIMEZONE

echo '==> Setting time zone to '$(cat /etc/timezone)

echo '==> Updating Debian repositories'

apt-get -q=2 update

echo '==> Installing Linux tools'

apt-get -q=2 install software-properties-common apt-transport-https tree zip unzip pv whois &>/dev/null

echo '==> Installing Git'

apt-get -q=2 install git &>/dev/null

echo '==> Installing python (pipx wheel)'

apt-get -q=2 install python3-pip python3-wheel python3-setuptools python3-argcomplete pipx &>/dev/null

Installing argcomplete with
pipx ensurepath

echo '==> Cleaning apt cache'

apt-get -q=2 autoclean
apt-get -q=2 autoremove

echo '==> zscaler'
cp zscaler.pem /usr/local/share/ca-certificates
chmod 644 /usr/local/share/ca-certificates/zscaler.pem
pip config set global.cert /usr/local/share/ca-certificates/

echo '==> Versions:'

lsb_release -d | cut -f 2
openssl version
curl --version | head -n1 | cut -d '(' -f 1
git --version
python3 --version

