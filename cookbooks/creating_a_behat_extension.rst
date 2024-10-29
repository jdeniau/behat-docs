Creating a Behat extension
==========================

Extensions are particularly useful when configuration becomes a necessity.

In this cookbook, we will create a simple extension named ``LogsExtension`` that logs scenario durations and cover:

#. Setting up the context
#. Creating the extension
#. Initializing the context

Setting Up the Context
----------------------

First, we need to create a class that will handle the logging. There are several ways to do this (you can hook
directly into behat's event dispatcher, for example).

For our case, we will create a `Context` and use the :doc:`normal tagged hooks</user_guide/context/hooks>`
that you might have used in your own contexts.

This is a straightforward approach, and means we can also show how to initialise any context with custom
configuration or dependencies.
The ``LogsExtension`` will provide a ``LogsContext`` that hooks into scenarios to log their start and end times.

Directory structure:

.. code-block::
  
  src/
      Context/
          LogsContext.php   # This is where we'll implement our logging logic


The code for ``LogsContext.php``:

.. code-block:: php

  <?php
  
  namespace Behat\LogsExtension\Context;
  
  use Behat\Behat\Context\Context;
  use Behat\Behat\Hook\Scope\BeforeScenarioScope;
  use Behat\Behat\Hook\Scope\AfterScenarioScope;
  
  class LogsContext implements Context
  {
      /** @BeforeScenario */
      public function before(BeforeScenarioScope $scope)
      {
          if (/* enable config */ === false) {
              return;
          }

          file_put_contents(
              /* filepath */,
              'START: ' . $scope->getScenario()->getTitle() . ' - ' . time() . PHP_EOL,
              FILE_APPEND
          );
      }
  
      /** @AfterScenario */
      public function after(AfterScenarioScope $scope)
      {
          if (/* enable config */ === false) {
              return;
          }
  
          file_put_contents(
              /* filepath */,
              'END: ' . $scope->getScenario()->getTitle() . ' - ' . time() . PHP_EOL,
              FILE_APPEND
          );
      }
  }

Creating the Extension
----------------------

Next, we need to create the extension itself.
This will serve as the entry point for our logging functionality.

Directory structure:

.. code-block::
  
  src/
      Context/
          LogsContext.php
      ServiceContainer/
          LogsExtension.php   # This is where we'll define our extension

To ensure Behat can find and load the ``LogsExtension.php`` file, it is important to place it within the `ServiceContainer` folder.
While there might be alternatives, we will stick to the straightforward method.

The ``getConfigKey`` method is used to identify our extension in the configuration, and the ``configure`` method is used to define the configuration tree.

The code for `LogsExtension.php`:

.. code-block:: php
  
  <?php
  
  namespace Behat\LogsExtension\ServiceContainer;
  
  use Behat\Testwork\ServiceContainer\Extension;
  use Behat\Testwork\ServiceContainer\ExtensionManager;
  use Symfony\Component\Config\Definition\Builder\ArrayNodeDefinition;
  use Symfony\Component\DependencyInjection\ContainerBuilder;
  
  class LogsExtension implements Extension
  {
      public function getConfigKey()
      {
          return 'logs_extension';
      }
  
      public function initialize(ExtensionManager $extensionManager)
      {
          // Empty for our case, but useful to hook into other extensions' configurations
      }

      public function configure(ArrayNodeDefinition $builder)
      {
          $builder
              ->addDefaultsIfNotSet()
              ->children()
                  ->scalarNode('enable')->defaultFalse()->end()
                  ->scalarNode('filepath')->defaultValue('behat.log')->end()
              ->end()
          ;
      }
  
      public function load(ContainerBuilder $container, array $config)
      {
          // ... we'll load our configuration here
      }

      public function process(ContainerBuilder $container)
      {
          // Empty for our case but needed for CompilerPassInterface
      }
  }

.. note::
  
  The ``initialize`` and ``process`` methods are empty in our case but are useful when you need to interact with other extensions or process the container after it has been compiled.

Initializing the Context
------------------------

To pass configuration values to our ``LogsContext``, we need to create an initializer.

Directory structure:

.. code-block::
  src/
      Context/
          Initializer/
              LogsInitializer.php   # This will handle context initialization
          LogsContext.php
      ServiceContainer/
          LogsExtension.php

The code for ``LogsInitializer.php``:

.. code-block:: php  
  <?php

  namespace Behat\LogsExtension\Context\Initializer;

  use Behat\LogsExtension\Context\LogsContext;
  use Behat\Behat\Context\Context;
  use Behat\Behat\Context\Initializer\ContextInitializer;

  class LogsInitializer implements ContextInitializer
  {
      private string $filepath;
      private bool $enable;
  
      public function __construct(string $filepath, bool $enable)
      {
          $this->filepath = $filepath;
          $this->enable = $enable;
      }
  
      public function initializeContext(Context $context)
      {
          if (!$context instanceof LogsContext) {
              return;
          }

          $context->initializeConfig($this->enable, $this->filepath);
      }
  }

We need to register the initializer definition within the Behat container through the ``LogsExtension``, ensuring it gets loaded:

.. code-block:: php
  <?php

  // ...

  use Symfony\Component\DependencyInjection\Definition;
  use Behat\Behat\Context\ServiceContainer\ContextExtension;

  class LogsExtension implements Extension
  {
      // ...
  
      public function load(ContainerBuilder $container, array $config)
      {
          $definition = new Definition(LogsInitializer::class, [
              $config['filepath'],
              $config['enable'],
          ]);
          $definition->addTag(ContextExtension::INITIALIZER_TAG);
          $container->setDefinition('logs_extension.context_initializer', $definition);
      }

      // ...
  }

To complete the extension, we must add methods to ``LogsContext`` to receive the configuration values and use those in the hooks:

.. code-block:: php

  // ...
  
  class LogsContext implements Context
  {
      private bool $enable = false;
      private string $filepath;
  
      public function initializeConfig(bool $enable, string $filepath)
      {
          $this->enable = $enable;
          $this->filepath = $filepath;
      }
  
      /** @BeforeScenario */
      public function before(BeforeScenarioScope $scope)
      {
          if ($this->enable === false) {
              return;
          }

          file_put_contents(
              $this->filepath,
              'START: ' . $scope->getScenario()->getTitle() . ' - ' . time() . PHP_EOL,
              FILE_APPEND
          );
      }
  
      /** @AfterScenario */
      public function after(AfterScenarioScope $scope)
      {
          if ($this->enable === false) {
              return;
          }
  
          file_put_contents(
              $this->filepath,
              'END: ' . $scope->getScenario()->getTitle() . ' - ' . time() . PHP_EOL,
              FILE_APPEND
          );
      }
  }

Conclusion
----------

Congratulations! You have just created a simple Behat extension that logs scenario durations. This extension demonstrates the three essential steps to building a Behat extension: defining an extension, creating an initializer, and configuring contexts.

Feel free to experiment with this extension and expand its functionality. For further learning, check out the `Behat hooks documentation <https://behat.org/en/latest/user_guide/context/hooks.html>`_ and explore existing extensions on `GitHub <https://github.com/search?o=desc&q=behat+extension+in%3Aname%2Cdescription+language%3APHP&ref=searchresults&s=stars&type=Repositories>`_.

Happy testing!
