FROM python:3.6-alpine

ARG WORKFLOW
RUN apk add make

COPY ./${WORKFLOW} /opt 

RUN make -C /opt init-pip

COPY tools/ /tools
COPY scripts/ /scripts

COPY rnaseq/ /opt

WORKDIR /opt

ENTRYPOINT ["make"]

CMD ["pack"]
