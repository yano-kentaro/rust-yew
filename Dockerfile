FROM debian:buster-slim

ENV RUSTUP_HOME=/usr/local/rustup \
	CARGO_HOME=/usr/local/cargo \
	PATH=/usr/local/cargo/bin:$PATH \
	RUST_VERSION=1.58.1

# apt-get install するパッケージは下記を参考に増やしている
# https://gist.github.com/shun115/2026632
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
	zsh zsh-dev \
	curl \
	make \
	ca-certificates \
	gcc \
	g++ \
	emacs \
	emacs-goodies-el \
	git \
	subversion \
	zlib1g \
	libc6-dev \
	libssl-dev \
	wget \
	pkg-config \
	; \
	dpkgArch="$(dpkg --print-architecture)"; \
	case "${dpkgArch##*-}" in \
	amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='3dc5ef50861ee18657f9db2eeb7392f9c2a6c95c90ab41e45ab4ca71476b4338' ;; \
	armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='67777ac3bc17277102f2ed73fd5f14c51f4ca5963adadf7f174adf4ebc38747b' ;; \
	arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='32a1532f7cef072a667bac53f1a5542c99666c4071af0c9549795bbdb2069ec1' ;; \
	i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='e50d1deb99048bc5782a0200aa33e4eea70747d49dffdc9d06812fd22a372515' ;; \
	*) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
	esac; \
	url="https://static.rust-lang.org/rustup/archive/1.24.3/${rustArch}/rustup-init"; \
	wget "$url"; \
	echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
	chmod +x rustup-init; \
	./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
	rm rustup-init; \
	chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
	rustup --version; \
	cargo --version; \
	rustc --version; \
	apt-get remove -y --auto-remove \
	wget \
	; \
	rm -rf /var/lib/apt/lists/*;


# DevelopersIOの記事を参考に、以下を修正
# https://dev.classmethod.jp/articles/yew-firststep/

RUN cargo install --locked trunk
RUN cargo install cargo-edit

RUN USER=root cargo new --lib yew-app
WORKDIR /yew-app
RUN cargo add yew
RUN cargo add wasm-bindgen
RUN cargo add wasm-logger
RUN rustup target add wasm32-unknown-unknown

COPY ./index.html /yew-app/index.html
COPY ./main.rs /yew-app/src/main.rs