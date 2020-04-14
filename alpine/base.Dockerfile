FROM alpine:3.11 as libvips-builder

ENV LIBVIPS_VERSION=8.9.1

WORKDIR /libvips/builder

RUN apk add --no-cache g++ make pkgconfig glib-dev expat-dev libexif giflib cairo-dev librsvg-dev libpng && \ 
    wget https://github.com/libvips/libvips/releases/download/v$LIBVIPS_VERSION/vips-$LIBVIPS_VERSION.tar.gz -O vips.tar.gz && \
    tar xf vips.tar.gz && \
    cd vips-$LIBVIPS_VERSION && \
    # chmod +x configure && ./configure --prefix=/libvips/output | tee /libvips/configure.log && \
    chmod +x configure && ./configure --prefix=/libvips/output && \
    make && make install
    
FROM alpine:3.11 as libvips-base

COPY --from=libvips-builder /libvips/output /usr/
