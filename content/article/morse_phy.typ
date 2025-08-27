#import "../../typ/templates/blog.typ": *
#import "../../typ/packages/physica.typ": *
#let title = "I Know What Mountain Looks Like: A Brief Story about Morse Theory in Physics"
#let grad = math.nabla
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

#let theorem(name: none, body) = {
  box(
    stroke: 1pt + dash-color,
    width: 100%,
    inset: (x: 8pt, y: 8pt),
    [
      #if name != none [*Theorem* (#emph(name))] else [*Theorem*]
      #body
    ],
  )
}

#let proof(name: none, body) = {
  block(
    stroke: 1pt + dash-color,
    width: 100%,
    inset: (x: 8pt, y: 8pt),
  )[
    #if name != none [_Proof_. (#emph(name)). ] else [_Proof_. ]
    #body
    #h(1fr)
    $qed$
  ]
}



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

Now we want to estimate the size of an instanton.
We only take the single instanton solution into account here.
We consider the instanton configuration $A-> B$.
Let $T = tau_(B)-tau_(A)$, then, as $tau -> T$, $x$ would approach $x_B$, and the instanton equation would become:
$
  frac(dif, dif tau) x(tau) = omega(x_(B))(a - x(tau)),
$
thus, the solution would be given by $x_(B) - x(tau) tilde upright(e)^(- omega(x_(B)) (tau - tau_0))$.
Thus, the instanton would be localized around $tau_(0)$ with a width of $1 / omega(x_(B))$.
Using this intuition, in a propagation process from $x_A$ to $x_B$, the instanton would be localized around some $tau_0$.
So that we can introduce the one instanton contribution as:
$
  cal(M)(A, B; t_(A), t_(B)) = upright(e)^(- omega (tau_(B) - tau_(B)) \/ 2) integral_(tau_(A))^(tau_(B)) dif tau thin A upright(e)^(upright(i) S_(c,1)) ,
$
where $tau$ is where the instanton localized on, and $A$ is defined as:
$
  integral_(tau_(A))^(tau_(B)) dif tau thin A = [ frac(det(- diff_(tau)^(2) + omega^(2)), det(- diff_(tau)^(2) + V''(x_(c)))) ]^(1\/2),
$
and $V''(x_(A,B)) = m omega^(2)$.
The original determinant could be written as $K^(-1\/2)_("ins") = e^(- omega tau \/ 2) A$, where the first term could be removed by some proper phase shift in real time.


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
To simplify the discussion, we will restrict ourselves to one dimension in this section.

=== Zero Mode

Near the instanton path $x_(c)$, we could write the action up to second order as:
$
  upright(i) S[x(t)] = upright(i) S[x_(c)(t)] - frac(1, 2) integral_(tau_(A))^(tau_(B)) dif tau thin delta x(tau) [- frac(dif^(2), dif tau^(2)) + V''(x_(c)(tau))] delta x(tau).
$
To simplify the consideration, we would assume $tau_(A,B) -> plus.minus oo$, thus $x_(A,B)$ would be two critical prints of the potential $V(x)$, i.e., the classical ground state of the system.

However, the ratio $A$ is not well-defined in our case.
Note that the Newtonian equation of motion is given by:
$
  - frac(dif^(2), dif tau^(2)) x_(c)(tau) + V'(x_(c)(tau)) = 0,
$
where $x_(c)(tau)$ and $x_(c)(tau + eta)$ will both satisfies the equation above, then, at the linear order, we have:
$
  [- diff_(tau)^(2) + V''(x_(c)(tau))] diff_(tau) x_(c) = 0,
$
which means that the instanton path $diff_(tau)x_(c)(tau)$ is a zero mode of the operator $- diff_(tau)^(2) + V''(x_(c)(tau))$.



=== Determinant with Zero Mode

To evaluate the determinant, we need to use a more careful treatment of the zero mode.
Consider eigenstates of the operator $- diff_(tau)^(2) + V''(x_(c)(tau))$, we can expand the degree of freedom as $delta x(t) = sum_(n) c_(n) x_(n)(t)$, where $x_(n)(t)$ is the $n$-th eigenstate of the operator $- diff_(tau)^(2) + V''(x_(c)(tau))$.
Then we can write the path integral for first $N$-th eigenstates as:
$
  K_("ins",N)^(-1\/2)
  = & A_(N) integral product_(n=1)^(N) frac(dif c_(n), sqrt(2pi)) thin e^(upright(i) S[x_(c)(t) + sum_(n=1)^(N) c_(n) x_(n)(t)]) \
  = & A_(N) integral_(-oo)^(+oo) frac(dif c_(1), sqrt(2pi)) thin (attach(det', br: N) [- diff_(tau)^(2) + V''(x_(c)(tau))])^(-1\/2),
$
where $attach(det', br: N)$ denotes the determinant with the first $N$-th eigenstates and remove the zero mode. And $A_(N)$ is a normalization factor would be determined by harmonic oscillator.
Since the normalized zero mode is given by $x_1(tau) = frac(dot(x)_(c)(tau), sqrt(S_0))$, the determinant could be written as:
$
  K_("ins",N)^(-1\/2) = A_(N) sqrt(frac(S_(0), 2pi)) integral_(-oo)^(+oo) dif tau thin (attach(det', br: N) [- diff_(tau)^(2) + V''(x_(c)(tau))])^(-1\/2),
$
thus, we can recover the original determinant as $K_( "ins")^(-1\/ 2) = lim_(N->oo) K_( "ins",N)^(-1 \/ 2)$.
Moreover, the instanton amplitude $A$ would be defined as:
$
  A = sqrt(frac(S_(0), 2pi)) (frac(det[-diff^(2)_(tau) + omega^(2)], det' [- diff_(tau)^(2) + V''(x_(c)(tau))]))^(1\/2).
$
=== Calculating the Determinant

Now we want to get the determinant which removes the zero mode.
By definition, the determinant (removed the zero mode) is given by:
$
  det'[- diff_(tau)^(2) + W(tau)] = product_(n=2) lambda_(n),
$
where the $lambda_n$ are the eigenvalues of the operator $- diff_(tau)^(2) + V''(x_(c)(tau))$, which could be defined as:
$
  [- diff_(tau)^(2) + W(tau)] x_(n)(tau) = lambda_(n) x_(n)(tau),
$
where $x_(n)(tau)$ are en eigenstate of the operator, if and only if $x_(n)$ satisfies the boundary condition $x_(n)(plus.minus oo) = 0$.
To evaluate the determinant properly, we would firstly consider the equation supports on $[-T\/2, T \/2]$, then remove the lowest eigenvalue $lambda_(1)$, and take the limit $T -> plus oo$.

The theorem below gives us the ratio of the determinants of two operators with the same boundary condition, which is given by:

#theorem(
  [The ratio of determinants is:
    $
      det [frac(- diff_(tau)^(2) + W_1(tau) - lambda, -diff_(tau)^(2) + W_2(tau) - lambda)] = frac(x^((1))_(lambda)(T \/ 2), x^(2)_(lambda)(T \/ 2)),
    $
    where $x_(lambda)^(1,2)$ satisfies the boundary condition $x_(lambda)^(1,2)(plus.minus T\/2) = 0$ and $diff_(tau) x_(lambda)^(1,2)(-T \/ 2) = 1$.
  ],
)

You can check the proof of this theorem #link("https://rgjha.github.io/gallery/AOS_Coleman.pdf")[here].
In our problem, we have $W_1(tau) = V''(x_(c)(tau))$ and $W_2(tau) = omega^(2)$, thus the ratio of the determinants is given by:
$
  A = sqrt(frac(S_(0), 2pi)) (frac(det[- diff_(tau)^(2) + omega^(2)], det' [- diff_(tau)^(2) + V''(x_(c)(tau))]))^(1\/2) = lim_(T-> oo) sqrt(frac(S_0, 2pi)) frac(x_(1)(T \/ 2), lambda_0 upright(e)^(T) \/ 2),
$
so the next step is to calculate the eigenvalue $lambda_0$ and the function $x_(1)(tau)$.

We note that the (normalized) eigenstate could be written as $x_(1)(tau) = S_0^(-1\/ 2) dot(x)_(c)(tau) -> a upright(e)^(-tau)$, while $tau -> + oo$.
Using this could help us to construct the eigenfunction $x_(lambda_0)(tau) = frac(1, 2a) (upright(e)^(tau \/ 2) x_(1)(tau) + e^(-tau \/ 2) y_(1)(tau))$, where $y_1(tau)$ could be derived from the Wronskian:
$
  x_1 diff_(tau) y_1 - y_1 diff_(tau) x_1 = 2 a^(2),
$
thus we have $y_(1)(tau) -> a upright(e)^(tau)$ while $tau -> oo$.
The eigenfunction at $tau = T \/ 2$ is $x_(lambda_0)(T \/ 2) = 1$ and $lambda_0 = 4 A^(2) e^(-T)$.
So that for large $T$, we have:
$
  A = sqrt(frac(S_(0), 2pi)) frac(1, 2a^(2)),
$
where $a$ is determined by the normalization condition:
$
  tau = integral_(0)^(x_(c)(tau)) dif x thin sqrt(2 V(x)) = - ln [S_0^(-1\/2) a^(-1)(x_(B) - x_(c)(tau))] + cal(O)(x_(B) - x_(c)(tau)).
$

= 'Taming' Infinity: Supersymmetric Quantum Mechanics

The difficulties in calculating the instanton determinant above arise from the infinite dimensional nature of the path integral.
Which would arise in calculating the determinant of the operator $- diff_(tau)^(2) + V''(x_(c)(tau))$.
If we can find a way to remove such infinite number of degrees of freedom (in the calculation of the determinant is infinite number of eigenstates), then we can calculate the instanton determinant easily by tracking the finite product of the eigenvalues.

== $A \/ A = 1$

To achieve this, a natural idea comes from Grassmannian integral, where the Gaussian integral of Grassmannian variables would give us
$
  integral dif psi dif overline(psi) thin upright(e)^(- overline(psi) A psi) = det(A),
$
which is the determinant of the matrix $A$.
Thus, if we can find a way to introduce some Grassmannian variables to the system, such that the determinant would appear neither in the Bosonic part as $(det(A))^(-frac(1, 2))$ but also in the Fermionic part as $det(B)$.
If one introduce $B = A^(1\/ 2)$, the infinite dimensional part would be removed automatically.

The physical realization of this is called _supersymmetry_.
In supersymmetric quantum mechanics, we introduce some Fermionic variables $psi$ and $overline(psi)$ to the system, such that the Lagrangian of the system would become:
$
  upright(i) S[x,psi,overline(psi)] = - integral dif tau thin [ frac(1, 2) angle.l dot(x), dot(x) angle.r + frac(1, 2) angle.l grad h(x), grad h(x) angle.r+ angle.l overline(psi) , (diff_(tau) + grad^(2) h(x)) psi angle.r ],
$
where we have $V(x) = frac(1, 2) (grad h(x))^(2)$ and $angle.l , angle.r$ is the natural pairing induced by the metric on the space.
In order to remove the infinite dimensional part in the determinant of the Bosonic part (here comes from $x$), we need to let the Fermionic part satisfy the periodic boundary condition instead of the anti-periodic boundary condition, which is usually used in finite temperature field theory.

The classical equation of motion of the system is given by $dot(x) = plus.minus grad h$, thus the classical ground state of the system is given by the critical points of the Morse function $h$.
Around the classical ground state(s) $x_(i)$, we can expand the action up to second order as:
$
  upright(i)S[delta x, psi, overline(psi)] = - integral dif tau thin [ frac(1, 2) angle.l delta x, ( - diff_(tau)^(2) + (grad^(2) h(x_(i)))^(2)) delta x angle.r + angle.l overline(psi), (diff_(tau) + grad^(2) h(x_(i))) psi angle.r ],
$
and the path integral around the classical ground state is given by (where the modes of $x$ and $psi, overline(psi)$ are all periodic, thus $diff_(tau)$ has eigenvalues $n$):
$
  integral cal(D)[delta x] cal(D)[psi] cal(D)[overline(psi)] thin upright(e)^(upright(i) S[delta x, psi, overline(psi)]) = frac(det (diff_(tau)+ nabla^(2) h(x_(i))), sqrt(det(- diff_(tau)^(2) + (nabla^(2) h(x_(i)))^(2))))
  = frac(det(nabla^(2)h(x_(i))), |det(nabla^(2) h(x_(i)))|).
$
After summing over all the classical ground states, we would get:
$
  tr(-1)^(F) upright(e)^(-beta H) = sum_(x_(i): "critical points of" h) frac(det(nabla^(2) h(x_(i))), |det(nabla^(2) h(x_(i)))|) = sum_(i) "sgn"(det(nabla^(2) h(x_(i)))),
$
which is the Morse characteristic of the manifold.

=== Instanton Moduli

Supersymmetry gives a strong constrain of the possible structure of instantons.
In this section, we want to prove that the time shifting $tau -> tau + delta tau$ is the only possible deformation of the instanton which preserves the instanton equation.

The general deformation of the instanton path up to the first order could be written as
$
  cal(D)_(plus.minus) delta x := diff_(tau) delta x plus.minus diff^(2)_(x) h delta x = 0,
$
thus, the possible deformation could be determined by the kernel of the operator $cal(D)_(plus.minus)$.

== Instanton Lifted Classical Ground States

At the discussion of spontaneous symmetry breaking, we have seen that, the instanton effect would lift some classical ground states of the system due to the existence of quantum tunneling.
The same thing would happen in our case.
The instanton whose path connects two classical ground states $x_(i)$ and $x_(i+1)$ would make them no longer the ground states of the system in quantum level.

To compute the instanton effect, we need to consider the path integral around the instanton path $x_(c)(tau)$, which satisfies the instanton equation with the boundary condition $x(- oo) = x_(i)$ and $x(+ oo) = x_(i+1)$.
