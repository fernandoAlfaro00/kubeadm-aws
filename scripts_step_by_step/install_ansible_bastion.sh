sudo yum install curl -y

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

python3 get-pip.py --user

python3 -m pip -V

python3 -m pip install --user ansible

echo "export PATH=$PATH:~/.local/bin" >> ~/.bashrc


# python3 -m pip list
# ansible --version