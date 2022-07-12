FROM quay.io/ncigdc/bio-alpine:py36-8dee591

ARG WORKFLOW

COPY ./${WORKFLOW} /opt 
COPY requirements.txt /opt
# TODO: Copy additional directories as needed
COPY ./tools /tools

RUN apk add make
RUN pip3 install -r /opt/requirements.txt

WORKDIR /opt

ENTRYPOINT ["make"]

CMD ["pack"]
