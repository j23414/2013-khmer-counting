t=yes curses=no cairo=no#!/bin/bash

# Die early if there is any problem
set -x -e

# Install pre-requisites (these are included with Starcluster)

apt-get -y update && apt-get -y install git make gcc g++ bc zlib1g-dev python-pip \
                    python-dev python-jinja2 python-tornado python-nose screen  \
                    python-numpy python-matplotlib

## clean up
rm -r /usr/local/src/* 

# Install Turtle
cd /usr/local/src
wget http://bioinformatics.rutgers.edu/Static/Software/Turtle/Turtle-0.3.1.tar.gz 
#wget http://bioinformatics.rutgers.edu/Static/Software/Turtle/Turtle-0.3.tar.gz
tar zxvf Turtle-0.3.1.tar.gz
cd Turtle-0.3/
make
mv *Turtle32 *Turtle64 /usr/local/bin/

# Install KAnalyze
cd /usr/local/src
#wget --timeout=1 --waitretry=0 --tries=2 --retry-connrefused "http://downloads.sourceforge.net/project/kanalyze/v0.9.3/kanalyze-0.9.3-linux.tar.gz"
wget --timeout=10 --tries=20 --retry-connrefused --no-check-certificate --secure-protocol=TLSv1 http://downloads.sourceforge.net/project/kanalyze/v0.9.3/kanalyze-0.9.3-linux.tar.gz
tar zxvf kanalyze-0.9.3-linux.tar.gz



# Install QUAST
cd /usr/local/src
#wget --timeout=1 --waitretry=0 --tries=2 --retry-connrefused "http://downloads.sourceforge.net/project/quast/quast-2.3.tar.gz"
wget --timeout=10 --tries=20 --retry-connrefused --no-check-certificate --secure-protocol=TLSv1 http://downloads.sourceforge.net/project/quast/quast-2.3.tar.gz
tar zxvf quast-2.3.tar.gz



# Install Tallymer
cd /usr/local/src
wget http://genometools.org/pub/genometools-1.5.1.tar.gz
tar zxvf genometools-1.5.1.tar.gz
cd genometools-1.5.1/
make 64bit=yes curses=no cairo=no errorcheck=no
make 64bit=yes curses=no cairo=no errorcheck=no install



# Install Jellyfish
cd /usr/local/src
wget http://www.cbcb.umd.edu/software/jellyfish/jellyfish-1.1.10.tar.gz
tar zxvf jellyfish-1.1.10.tar.gz
cd jellyfish-1.1.10/
./configure
make
make install

# Install DSK
cd /usr/local/src
ldconfig
wget http://minia.genouest.org/dsk/dsk-1.5031.tar.gz
tar zxvf dsk-1.5031.tar.gz
cd dsk-1.5031
make omp=1
cp dsk /usr/local/bin

# Install KMC
cd /usr/local/src
wget http://sun.aei.polsl.pl/kmc/download/kmc
wget http://sun.aei.polsl.pl/kmc/download/kmc_dump
chmod u+x kmc kmc_dump
mv kmc kmc_dump /usr/local/bin/


# Install BFCount
cd /usr/local/src
git clone https://github.com/pmelsted/BFCounter.git
cd BFCounter/
make
mv ./BFCounter /usr/local/bin/

# Install FASTX-toolkit
cd /usr/local/src
curl -O http://hannonlab.cshl.edu/fastx_toolkit/libgtextutils-0.6.1.tar.bz2
tar xjf libgtextutils-0.6.1.tar.bz2
cd libgtextutils-0.6.1/
./configure && make && make install

#cd /usr/local/src
#curl -O http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit-0.0.13.2.tar.bz2
#tar xjf fastx_toolkit-0.0.13.2.tar.bz2
#cd fastx_toolkit-0.0.13/
#./configure && make && make install

sudo apt-get install fastx-toolkit

# Install Trimmomatic #
cd /usr/local/src
curl -O http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.30.zip
unzip Trimmomatic-0.30.zip
cd Trimmomatic-0.30/
cp trimmomatic-0.30.jar /usr/local/bin
cp -r adapters /usr/local/share/adapters

# Install seqtk
cd /usr/local/src
git clone git://github.com/lh3/seqtk.git
cd seqtk
make
cp seqtk /usr/local/bin

# install Java
sudo apt-get install default-jre
#cd /usr/local/src
#wget http://uni-smr.ac.ru/archive/dev/java/JRE/7/JRE-7.51/jre-7u51-linux-x64.tar.gz 
#tar zxvf jre-7u51-linux-x64.tar.gz 


# Install ipython

#cd /usr/local/src
#git clone https://github.com/ipython/ipython.git
#cd ipython
#python setup.py install

sudo apt-get install ipython

# Upgrade pyzmq, which is required by ipython notebook
pip install pyzmq --upgrade

# Upgrade some other packages required by ipython notebook to draw figures

# numpy
sudo pip install cython
cd /usr/local/src
git clone git://github.com/numpy/numpy.git numpy
cd numpy
python setup.py install

cd /usr/local/src
pip install pandas
pip install --upgrade patsy
apt-get install libfreetype6-dev
apt-get install libpng-dev
pip install matplotlib
sudo apt-get install pkg-config
sudo apt-get install libblas-dev liblapack-dev
pip install seaborn
pip install --upgrade six
pip install --upgrade statsmodels
sudo pip install "Tornado>=4.0.0,<5.0.0"
#pip install --upgrade tornado


# Upgrade the latex install with a few recommended packages
apt-get -y install texlive-latex-recommended

cd /usr/local/src
# Install Velvet
#curl -O http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz
sudo wget https://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz
tar xvzf velvet_1.2.10.tgz
cd velvet_1.2.10/
make 'MAXKMERLENGTH=49'
cp velveth /usr/bin
cp velvetg /usr/bin

cd /usr/local/src

git clone git://github.com/ged-lab/screed.git
cd screed
git checkout 2013-khmer-counting
python setup.py install

cd /usr/local/src
git clone http://github.com/ged-lab/khmer.git
cd khmer
git checkout 2013-khmer-counting
sed -i 's/http:\/\/pypi.python.org\/packages\/source\/d\/distribute\//https:\/\/pypi.python.org\/packages\/source\/d\/distribute\//g' /usr/local/src/khmer/python/distribute_setup.py
make test

cd /usr/local/src
echo 'export PYTHONPATH=/usr/local/src/khmer/python' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/src/khmer/scripts' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/src/khmer/sandbox' >> ~/.bashrc
source ~/.bashrc
