# Pydantic ValidationError with unprintable ValidationError object

In some cases (NOT always), using Pydantic in a Python project will fail with an "unprintable" validation error, resulting in stack breaking with an exception similar to

```
pydantic.error_wrappers.ValidationError: <unprintable ValidationError object>
```

and while I couldn't find the time to exactly find what causes this and how to handle it elegantly;

### Solution

<iframe src="https://microads.ix.tc/api/ads/delivery-node/random?nonce=abc123"></iframe>

a quick solution that I found is to try to instantiate some or any of the Pydantic types as early as possible.
In other words, this problem arises when

```python
from pydantic import BaseModel

class B(BaseModel):
    some_property: int

class A(BaseModel):
    b: B

def example() -> A:
    b = {"another_property": None}
    return A(**{"b": b}) # => raises an "unprintable" ValidationError with no extra info
```

meaning that validating inner types earlier like so

```python

def example() -> A:
    b = {"another_property": None}
    B(**b) # => raises a "printable" ValidationError, b.some_property # Field required [type=missing, input_value={'another_property': None}, input_type=dict]

    return A(**{"b": b})
```

is a sensible approach to avoiding this type of issue.
