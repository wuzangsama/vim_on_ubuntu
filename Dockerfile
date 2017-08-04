FROM ubuntu:17.04

MAINTAINER Haifeng Zhang "zhanghf@zailingtech.com"

# 设置go相关环境变量
ENV GOLANG_VERSION 1.8.3
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
# 设置locale，进入终端可以输入中文
ENV LANG en_US.utf8
# 设置容器时区
ENV TZ "Asia/Shanghai"

RUN apt update -y \
# 安装开发工具包和man
    && apt install -y build-essential \
    && apt install -y subversion \
    && apt install -y git \
    && apt install -y man \
# 安装zsh和oh-my-zsh
    && apt install -y zsh \
    && apt install -y curl \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
    && chsh -s /bin/zsh \
# 安装vim需要的工具包
    && apt install -y cmake \
    && apt install -y clang \
    && apt install -y ctags \
    && apt install -y cscope \
    && apt install -y python \
    && apt install -y python-dev \
    && apt install -y ruby \
    && apt install -y ruby-dev \
    && apt install -y lua5.1 \
    && apt install -y liblua5.1-0-dev
    && apt install -y luajit \
    && apt install -y libluajit-5.1-dev \
    && apt install -y perl \
    && apt install -y libperl-dev \
    && apt install -y tcl \
    && apt install -y tcl-dev \
    && apt install -y libtcl8.6 \
    && apt install -y libncurses5-dev \
    && apt install -y silversearcher-ag \
    && apt install -y tmux \
    && apt install -y python3 \
    && apt install -y python3-dev \
    && apt install -y libtool \
    && apt install -y automake \
    && apt install -y wget \
# 清理
    && rm -rf /var/lib/apt/lists/*
# 安装go
RUN goRelArch='linux-amd64' \
    && url="https://golang.org/dl/go${GOLANG_VERSION}.${goRelArch}.tar.gz" \
    && wget -O go.tgz "$url" \
    && tar -C /usr/local -xzf go.tgz \
    && rm go.tgz \
    && go version

# 安装vim
COPY .vimrc /root/

RUN cd /usr/local/src \
    && git clone https://github.com/vim/vim.git \
    && cd vim \
    && git checkout v8.0.0858
    && ./configure --prefix=/usr \
        --with-features=huge \
        --enable-multibyte \
        --enable-cscope=yes \
        --enable-luainterp=yes \
        --with-luajit \
        --enable-rubyinterp=yes \
        --with-ruby-command=/usr/bin/ruby \
        --enable-perlinterp \
        --enable-pythoninterp=yes \
        --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/ \
        --enable-python3interp=yes \
        --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
        --enable-tclinterp=yes \
        --enable-gui=auto \
    && make \
    && make install \
    && cd .. \
    && rm -rf vim/ \
# 安装powerline字体
    && git clone https://github.com/powerline/fonts.git \
    && cd fonts \
    && ./install.sh \
    && cd .. \
    && rm -rf fonts/ \
# 安装vim初次启动需要的插件
    && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && git clone https://github.com/tomasr/molokai.git ~/.vim/bundle/molokai \
    && git clone https://github.com/Shougo/unite.vim.git ~/.vim/bundle/unite.vim \
    && git clone https://github.com/shougo/vimfiler.vim.git ~/.vim/bundle/vimfiler.vim \
# vim其他插件安装
    && vim +PlugInstall +qall

COPY mysnippets/* /root/.vim/bundle/ultisnips/mysnippets/
COPY .zshrc /root/
COPY .tmux.conf /root/

#work dir
WORKDIR /work

