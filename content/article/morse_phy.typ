#import "../../typ/templates/blog.typ": *
#import "../../typ/packages/physica.typ": *
#let title = "I Know What Mountain Looks Like: A Brief Story about Morse Theory in Physics"
#show: main.with(
  title: title,
  desc: [At a conference in 19 centry, Maxwell described a way to derive the structure of mountain without climbing or even seeing it. From this story, 我们会走过上世纪 80 年代开始的，数学物理之间的一场“世纪婚礼”],
  date: "2025-08-18",
  tags: (
    blog-tags.physics,
    blog-tags.math,
    blog-tags.topology,
  ),
)

= A Man What to Know What Mountain Looks Like

= Mathematician's Consideration: Mores Flow and Morse Cohomology

= Instantons as Morse Flow

In quantum mechanics, people would meet a problem very similar to the problem to get the structure of a mountain by using a free-fall ball, but somehow 反过来：given a potential (which would forms a associated structure of mountain), we want to know how the ball would fall.
For example, one would ask: weather the ball would 跨过 a mountain, or would it 困在山的一边？

In classical mechanics, the answer for it is simple: if the ball has enough energy, precisely, if the energy of the ball is larger than the maximum of the potential, then the ball would cross the mountain, otherwise it would be trapped on one side of the mountain.

If we just consider such effect in classical level, such a question would give us almost nothing about the structure of the mountain, because we can only know the maximum of the potential, which denotes the height of the mountain, but not the shape of the mountain.

In quantum mechanics, everything would be considered in a probabilistic way. So there is a natural question: are there any probability for the ball to cross the mountain even if it does not have enough energy?

The answer is YES: the ball would have a probability to cross the mountain even if it does not have enough energy, and, suprisingly, this probability would related to the structure of the mountain, instead of just the height of the mountain.
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

The amptitude above could be calculated by using the path integral formulation of quantum mechanics, which states that the probability amplitude could be calculated by summing over all possible paths of the ball, weighted by the exponential of the action of the path:
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
  cal(M)(A, B; t_(A), t_(B)) -> sum_("Classical Pathes") ("Determinant from perturbation")^(-1 \/ 2) times e^(upright(i) S_(c)) .
$
The answer reveals that, the phase of the probability amplitude is determined by the classical action of the path.

== Instanton

While we want to use the formulation above to calculate the probability amplitude of the ball to cross the mountain,
we will meet a 毁灭性的 problem: there is NO classical path that crosses the mountain if the ball does not have enough energy!
So that we cannot use the saddle point method directly to calculate the probability amplitude.

However, there might be a 变通的 way to use it.
After introduce $tau = upright(i) t$, the phase term could be written as:
$
  upright(i) S[x(t)] = integral_(tau_(A))^(tau_(B)) dif tau thin [- frac(1, 2) dot(x)(tau)^(2) + V(x) ],
$
which could be viewed as a particle moving in a potential $-V(x)$ with imaginary time.
Thus, using the saddle point method, we could find a classical path that crosses the mountain in the potential $-V(x)$, which is called an _instanton_.

= Self-Dual Instanton Equation in Quantum Mechanics

= 驯化无限：Supersymmetric Quantum Mechanics
