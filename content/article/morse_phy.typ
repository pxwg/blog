#import "../../typ/templates/blog.typ": *
#import "../../typ/packages/physica.typ": *
#let title = "I Know What Mountain Looks Like: A Brief Story about Morse Theory in Physics"
#show: main.with(
  title: title,
  desc: [In the 19th century, Maxwell described how one could deduce the structure of a mountain without climbing it—or even seeing it. Following his spirit, we will witness another "great wedding of the century" between mathematics and physics—one that began in the 1980s, when supersymmetry and Morse theory united in a profound and revolutionary embrace.],
  date: "2025-08-18",
  tags: (
    blog-tags.physics,
    blog-tags.math,
    blog-tags.topology,
  ),
)

*Warning*: Chrome does not support MathML fully.
You can use Firefox to avoid these potential problems

= Prelude: A Man Wants to Know What Mountain Looks Like

= Mathematician's Consideration: Mores Flow and Morse Cohomology

= Tunneling and Path Integral

In the world of mechanics, we encounter a problem analogous to determining a mountain's structure by observing the trajectory of a free-falling ball—but in reverse.
Here, given a potential (which effectively shapes the "mountain"), we aim to predict how the ball (e.g., a quantum particle) will behave.
For instance: Will the ball tunnel through the mountain, or become trapped on one side?

In classical mechanics, the answer for it is simple: if the ball has enough energy, precisely, if the energy of the ball is larger than the maximum of the potential, then the ball would cross the mountain, otherwise it would be trapped on one side of the mountain.

If we just consider such effect in classical level, such a question would give us almost nothing about the structure of the mountain, because we can only know the maximum of the potential, which denotes the height of the mountain, but not the shape of the mountain.

In quantum mechanics, everything would be considered in a probabilistic way. So there is a natural question: are there any probability for the ball to cross the mountain even if it does not have enough energy?

The answer is YES: the ball would have a probability to cross the mountain even if it does not have enough energy, and, surprisingly, this probability would related to the structure of the mountain, instead of just the height of the mountain.
This is called _quantum tunneling_.

== Path Integral

To capture the effect of quantum tunneling, we need to calculate the probability amplitude of the ball to cross the mountain, which could be written as #footnote([We will always set $hbar = 1$ in this article.]):
$
  bra(B) e^(- upright(i) integral_(t_A)^(t_B) H dif t ) ket(A),
$
where $bra(B)$ and $ket(A)$ are the initial and final states of the ball, $H$ is the Hamiltonian of the system, could be written as:
$
  H = frac(p^(2), 2) + V(x),
$
and $t_A$ and $t_B$ are the initial and final times.

The amplitude above could be calculated by using the path integral formulation of quantum mechanics, which states that the probability amplitude could be calculated by summing over all possible paths of the ball, weighted by the exponential of the action of the path:
$
  bra(B) e^(- upright(i) integral_(t_A)^(t_B) H dif t ) ket(A) = integral_(x(t_(A))=x_(A))^(x(t_(B))=x_(B)) cal(D)[x(t)] thin e^(upright(i) integral_(t_(A))^(t_(B)) L[x(t)] dif t ) ,
$
where $L[x(t)]$ is the Lagrangian of the system, which is given by:
$
  L[x(t)] = frac(1, 2) dot(x)^(2) - V(x),
$

We could calculate it approximately by using the saddle point method,
which states that the integral could be approximated by the contribution of the paths that are close to the classical path,
which is the path that satisfies the Euler-Lagrange equation, in this case, we have:
$
  dot.double(x) = - V'(x) .
$
Where we assume $x(t_(A,B)) = x_(A,B)$.

To get the approximative value of the integral, we need to pertubate the classical path by a small perturbation and calculate the second order term of the action.
After integrating out such perturbation, we could get the probability amplitude as:
$
  cal(M)(A, B; t_(A), t_(B)) -> sum_("Classical Pathes") ("Determinant from perturbation")^(-1 \/ 2) times e^(upright(i) S_(c)) ,
$
where the determinant comes from the Gaussian integral of the perturbation around the instanton path.
We will denote it as $K$ later.

The answer reveals that, the phase of the probability amplitude is determined by the classical action of the path.

== Instanton

While we want to use the formulation above to calculate the probability amplitude of the ball to cross the mountain,
we will meet a catastrophic problem: there is NO classical path that crosses the mountain if the ball does not have enough energy!
So that we cannot use the saddle point method directly to calculate the probability amplitude.

However, there might be a workaround to use it.
After introduce $tau = -upright(i) t$, the phase term could be written as:
$
  upright(i) S[x(tau)] = - integral_(tau_(A))^(tau_(B)) dif tau thin [ frac(1, 2) dot(x)(tau)^(2) + V(x) ],
$
which could be viewed as a particle moving in a potential $-V(x)$ with imaginary time.
Thus, using the saddle point method, we could find a classical path that crosses the mountain in the potential $-V(x)$, which is called an _instanton_.

We want to get the value of the phase term under the classical path of the instanton.
Thanks to the real value of it, we can use some basic inequalities to get the maximum of the action, which is given by:
$
  upright(i) S[x(tau)]= - integral_(tau_(A))^(tau_(B)) frac(1, 2)( dot(x) -sqrt(2 V(x)) )^(2) dif tau - integral_(x_(A))^(x_(B)) sqrt(2 V(x)) dif x <= - integral_(x_(A))^(x_(B)) sqrt(2 V(x)) dif x,
$
thus the classical path of the instanton is governed by (where we assume $x_(A)< x_(B)$):
$
  dot(x) = sqrt(2 V(x)),
$
which is called _instanton equation_, and the action (called _instanton action_) would given by $upright(i)S_(c,0) = - integral_(t_(A))^(t_(B)) sqrt(2 V(x)) dif x$.
Thus, the probability amplitude of the ball to cross the mountain is given by:
$
  cal(M)(A, B; t_(A), t_(B)) = sum_("Instantons from "x_(A) "to" x_(B)) K_"ins"^(-1 \/ 2) times e^(- integral_(x_(A))^(x_(B)) sqrt(2 V(x)) dif x) ,
$
It's easy to see that the contribution of the instanton is  independent of the dynamics of the ball, but only depends on the potential and the path from $x_A$ to $x_B$.

If we consider a single mountain in $1$ dimension, then the path from $x_A$ to $x_B$ is unique, so the contribution of the instanton is also unique.

However, if we consider a mountain with multiple valleys and peeks, then the steepest descent path from one valley to a peek, or vise versa, would generally not be unique, then the contribution would be a sum over all such paths, which is given by:
$
  cal(M)(A, B; t_(A), t_(B)) = sum_("Instantons from "x_(A) "to" x_(B)) K_"ins"^(-1 \/ 2) times e^(- integral_(x_(A))^(x_(B)) sqrt(2 V(x)) dif x) ,
$
where the different instantons would correspond to different steepest descent paths from $x_A$ to $x_B$.

== A Shadow of Morse Theory

The discussion above hints us that, the structure of the quantum tunneling in a potential, might be similar to the structre of Morse theory.

To see this, we assume that the potential $V(x)$ is always positive and satisfies some basic conditions.
Thus, we can identify some potential with a Mores function $h(x)$ which is given by:
$
  V(x) = frac(1, 2) (grad h(x))^(2),
$
and thus the instanton equation would become Mores flow equation $dot(x) = - grad h(x)$, and the expression of the instanton action would become $S = - h(x_(B)) + h(x_(A))$,
which would not depends on the specific structure of various steepest descent paths,
but only depends on the value of the Morse function at the initial and final points.

Now we can see that the probability amplitude of the ball to cross the mountain is given by:
$
  cal(M)(A,B) = sum_("Instantons from "x_(A) "to" x_(B)) K_"ins"^(-1 \/ 2) times e^( - (h(x_(A)) - h(x_(B)))) ,
$
i.e. The probability amplitude could be calculated by the sum of all the contributions of the instanton fluctuations from $x_(A)$ to $x_(B)$, with a overall factor of $e^( h(x_(A)) - h(x_(B)))$.

== Instanton Determinant: A First Glance of Infinite Dimensions

Now we want to calculate the contribution of the instanton fluctuations, which is given by the determinant $K_"ins"^(-1 \/ 2)$.

= Taming Infinity: Supersymmetric Quantum Mechanics
