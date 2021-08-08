# Snippets for Using `lacledeslan/steamcmd` in Dockerfiles

## Linux

### Download and Extract 7z

```shell
RUN echo "Downloading" &&\
        mkdir --parents /tmp/ &&\
        curl -sSL "https://example.com/some-file.7z" -o /tmp/some-file.7z &&\
    echo "Validating download against known hash" &&\
        echo "A77293D1CEE5708BA2FAD2D3BDECBDBFDC3C44A4BC0698b5CF0D7CD4E6BAE54A  /tmp/some-file.7z" | sha256sum -c - &&\
    echo "Extracting" &&\
        7z x -o/output/ /tmp/some-file.7z &&\
        rm -f /tmp/some-file.7z;
```

### Download and Extract Zip

```shell
RUN echo "Downloading" &&\
        mkdir --parents /tmp/ &&\
        curl -sSL "https://example.com/some-file.zip" -o /tmp/some-file.7z &&\
    echo "Validating download against known hash" &&\
        echo "A77293D1CEE5708BA2FAD2D3BDECBDBFDC3C44A4BC0698b5CF0D7CD4E6BAE54A  /tmp/some-file.zip" | sha256sum -c - &&\
    echo "Extracting" &&\
        unzip /tmp/some-file.zip -d /output/ &&\
        rm -f /tmp/some-file.zip;
```
