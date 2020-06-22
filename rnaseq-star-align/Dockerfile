FROM python:3.6-alpine


ARG WORKFLOW

COPY ./${WORKFLOW} /opt 
COPY ./tools /tools
COPY ./scripts /scripts
COPY ./rnaseq/ /opt

RUN apk add make
RUN make -C /opt init-pip

WORKDIR /opt

ENTRYPOINT ["make"]

CMD ["pack"]
