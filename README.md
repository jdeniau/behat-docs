# Documentation & web content for docs.behat.org

This repo holds the content for https://docs.behat.org/, which is built and hosted on [Read the Docs Community](https://about.readthedocs.com/) (RtD).
https://behat.org and https://www.behat.org both redirect to this site.

At the moment, RtD does not feed build status back to GitHub for builds on a project's main branch(es). Instead, you
can find build history for each version on RtD.

| Version | Status                                                                                                                                                                        | Docs URL                          | Build dashboard                                                                                   |
|---------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|---------------------------------------------------------------------------------------------------|
| v2.5    | [![Documentation Status](https://readthedocs.org/projects/behat/badge/?version=v2.5&style=for-the-badge)](https://docs.behat.org/en/latest/?badge=v2.5)                       | https://docs.behat.org/en/v2.5/   | [v2.5 build history](https://app.readthedocs.org/projects/behat/builds/?version__slug=v2.5)       |
| v3.0    | [![Documentation Status](https://readthedocs.org/projects/behat/badge/?version=v3.0&style=for-the-badge)](https://docs.behat.org/en/latest/?badge=v3.0)                       | https://docs.behat.org/en/v3.0/   | [v3.0 build history](https://app.readthedocs.org/projects/behat/builds/?version__slug=v3.0)       |
| latest* | [![Documentation Status](https://readthedocs.org/projects/behat/badge/?version=latest&style=for-the-badge)](https://docs.behat.org/en/latest/?badge=v3.0&style=for-the-badge) | https://docs.behat.org/en/latest/ | ["latest" build history](https://app.readthedocs.org/projects/behat/builds/?version__slug=latest) |

> \* the "latest" version is currently also based off the v3.0 branch, but is a separate build on RTD.

## Project structure

The site is built using [sphinx](https://www.sphinx-doc.org/en/master/index.html), a python-based documentation
generator based on reStructuredText (.rst) or MyST Markdown (.md) files. Most content is populated in these files.

reStructuredText is similar to Markdown, with some differences. The following resources may be useful:

* RtD's [Getting started with RST tutorial](https://sphinx-tutorial.readthedocs.io/step-1/)
* The [Spinx reStructuredText primer](https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html)
* @waldyrious' [browser-based RST playground](https://waldyrious.net/rst-playground/)

Sphinx takes these .rst/.md source files and renders them into the final HTML site with the custom `borg` theme. You'll
find the templates and resources for this under the `_themes/borg` directory. The theme provides the overall page
layout, as well as features such as automatic contents pages and navigation.

## Previewing on GitHub

The GitHub web interface natively supports rendering both reStructuredText and Markdown files. For simple changes, this
is often the quickest way to check the formatting of your contribution. Custom sphinx tags & metadata (including some
navigation tags & internal links) will not be rendered, but the main content should appear roughly as it will in the
built version.

## Building locally

For more significant changes, you may want to build the full docs site locally. For this, you will need python, sphinx
and the relevant dependencies. The easiest solution may be to use a temporary docker container. In this repository you will
find a `Dockerfile` and a `docker-compose.yml` file that will let you do that easily

```bash
# Launch a docker container with the right dependencies and run the site build command
# This will build the container if needed, using the Dockerfile
docker compose run --rm read-the-docs-builder

# The docs will be generated into _build/html
# Check the CLI output for any errors
```

If you encounter problems, start by looking at the logs of the latest build on Read the Docs to see the commands that
were executed. It's possible that this README has got out of date with later changes to the build process.
