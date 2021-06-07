[![Build](https://github.com/sider/devon_rex/workflows/Build/badge.svg)](https://github.com/sider/devon_rex/actions/workflows/build.yml?query=branch%3Amaster)

# Devon Rex

This repository provides the Docker images for [Sider Runners](https://github.com/sider/runners).

The release tags indicate the Docker image tag, and all Docker images have the same tag.

* [devon_rex_base](https://hub.docker.com/r/sider/devon_rex_base)
* [devon_rex_dotnet](https://hub.docker.com/r/sider/devon_rex_dotnet)
* [devon_rex_go](https://hub.docker.com/r/sider/devon_rex_go)
* [devon_rex_haskell](https://hub.docker.com/r/sider/devon_rex_haskell)
* [devon_rex_java](https://hub.docker.com/r/sider/devon_rex_java)
* [devon_rex_npm](https://hub.docker.com/r/sider/devon_rex_npm)
* [devon_rex_php](https://hub.docker.com/r/sider/devon_rex_php)
* [devon_rex_python](https://hub.docker.com/r/sider/devon_rex_python)
* [devon_rex_ruby](https://hub.docker.com/r/sider/devon_rex_ruby)
* [devon_rex_swift](https://hub.docker.com/r/sider/devon_rex_swift)

## Development

This project depends on Ruby with the same version in the [`.ruby-version`](.ruby-version) file.
(we recommend [rbenv](https://github.com/rbenv/rbenv) to install Ruby)

To set up:

```console
$ bundle install
```

To build and test a Docker image:

```console
$ bundle exec rake docker:build docker:run BUILD_CONTEXT=base
```

We use ERB, which is a standard template engine of Ruby, to generate Dockerfiles.
So, if you want to update Dockerfiles, you need to use the `rake` command instead of editing the files directly.

For example:

```console
$ bundle exec rake dockerfile:generate
```

To see all the defined tasks:

```console
$ bundle exec rake --tasks
```

## License

See [LICENSE](LICENSE) for details.
