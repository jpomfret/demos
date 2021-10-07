# Create a class
class Foo {
    # Property
    [String]$Bar

    # Method
    [String] ShowBar () {
        return $this.Bar
    }

    # Constructor
    Foo ([String]$bar) {
        $this.Bar = $bar
    }

    # Default constructor - exists if we don't define others, worth defining otherwise
    Foo () {}
}

# create instances of classes
[Foo]::new('something')
# or
$foo = [Foo]::new()
$foo.Bar = 'somethingelse'
$foo.ShowBar()
# or
[Foo]@{
    Bar = 'but'
}


