FROM quay.io/ncigdc/gdc-rnaseq:latest AS rnaseq
FROM python:3.6-alpine

COPY --from=rnaseq /opt /opt


ARG WORKFLOW
RUN apk add make

# Copy subworkflow first so Makefile/Dockerfile not overwritten
# COPY gdc-rnaseq/ /opt 
COPY ./${WORKFLOW} /opt 

RUN make -C /opt init-pip

COPY tools/ /tools
COPY scripts/ /scripts

WORKDIR /opt

ENTRYPOINT ["make"]

CMD ["pack"]
