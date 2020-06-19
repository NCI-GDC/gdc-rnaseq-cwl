FROM python:3.6-alpine

COPY . /opt

RUN apk add make
RUN make -C /opt init-pip

WORKDIR /opt

ENTRYPOINT ["make"]

CMD ["pack"]
