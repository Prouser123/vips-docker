# Rewrite inspired by docker.io/argu/alpine-vips by @argu

FROM alpine:3.11

ENV LIBVIPS_VERSION=8.9.2

# Add add.deps script.
RUN echo -e "#!/bin/sh\napk add --no-cache --virtual vips-deps binutils g++ make pkgconfig glib-dev expat-dev libexif giflib cairo-dev librsvg-dev libpng jpeg-dev orc-dev giflib libwebp-dev tiff-dev openexr-dev" > /add.deps \
	# Add del.deps script
	&& echo -e "#!/bin/sh\napk del --purge vips-deps && rm -rf /var/cache-apk/*" > /del.deps \
	# Make the scripts executable.
	&& chmod +x /add.deps \
	&& chmod +x /del.deps \
	# Continue with dockerfile
	&& sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/alpine-cf-cdn.jcx.ovh/' /etc/apk/repositories \
	&& apk update \
	&& apk upgrade \
	&& /add.deps \
	&& wget  -O- https://github.com/libvips/libvips/releases/download/v$LIBVIPS_VERSION/vips-$LIBVIPS_VERSION.tar.gz | tar -xzC /tmp \
	&& cd /tmp/vips-$LIBVIPS_VERSION \
	&& ./configure --prefix=/usr \
                   --without-python \
                   --disable-static \
                   --disable-dependency-tracking \
                   --enable-silent-rules \
	&& make -s install-strip \
	&& cd / \
	&& rm -rf /tmp/vips-$LIBVIPS_VERSION \
	&& /del.deps \
	# Install runtime versions of deps.
	&& apk add --no-cache \
	glib librsvg cairo libpng libjpeg \
	giflib libwebp orc tiff openexr \
	&& rm -rf /var/cache-apk/*