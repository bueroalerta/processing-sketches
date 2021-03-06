// distance between branches. this kind of controls the fine detail of the leaves.s
float TOO_CLOSE_DIST = 2.5;
/**
 * < 0.5 always degenerates - no branching
 * 0.75 still has some degenerates
 * 0.75 to 1 - creates nicer complex boundaries
 * 1 - normal
 * 1 to 1.5 - makes more aristate and cuneate shapes
 * > 1.5 degenerates - vein crisscrossing
 */
float EXPAND_SCALAR = 0.85;

float EXPAND_DIST = TOO_CLOSE_DIST * EXPAND_SCALAR;
/**
 * max_path_cost
 * Linear scalar of how big the plant grows; good numbers are 100 to 1000.
 * For high fidelity, pump this up to like 5000
 */
float MAX_PATH_COST = 100;
/* sideways_cost_ratio
 * Powerful number that controls how fat the leaf grows.
 * -1 = obovate, truncate, obcordate
 * -0.2 = cuneate, orbicular
 * 0 = ellipse
 * 1+ = spear-shaped, linear, subulate
 */
float SIDEWAYS_COST_RATIO = 0.0;

/* side_angle
 * controls the complexity of the edge and angular look of the inner vein system
 *   <PI / 6 = degenerate "nothing grows" case.
 *   PI/6 to PI/2 = the fractal edge changes in interesting ways.
 *     generally at PI/6 it's more circular/round, and at PI/2 it's more pointy.
 */
float SIDE_ANGLE = PI / 3;
/**
 * side_angle_random
 * adds a random noise to every side_angle
 * at 0 the leaf looks perfectly straight/mathematically curvy
 * and allows for interesting fragile vein patterns to appear
 * 
 * as this bumps up the patterns will start to give way to chaos and
 * a more messy look.
 * This can open up the way for veins to flow in places they might not
 * have before.
 * This also risks non-symmetricness.
 *
 * Anything beyond like PI / 4 will be pretty messy. 
 */
float SIDE_ANGLE_RANDOM = PI / 6;

/**
 * turn_depths_before_branching
 * kind of like a detail slider - how dense do you want the veins to be.
 * 1 is messier and has "hair" veins
 * 2 is more uniform
 * 3+ bit spacious and e.g. gives room for turn_towards_x_factor
 * 6 is probably max here.
 */
int DEPTH_STEPS_BEFORE_BRANCHING = 2;

/**
 * branch_depth_mod
 * the period of small to big branching.
 * Larger periods tend to create more lobed/palmate boundary shapes.
 * Use in conjunction with SECONDARY_BRANCH_SCALAR.
 * 
 * 1 will create no secondary branches.
 * 2-10 creates larger crevases.
 * To get complex boundaries, DEPTH_STEPS_BEFORE_BRANCHING * BRANCH_DEPTH_MOD should be around 10-20.
 */
int SECONDARY_BRANCH_PERIOD = 2;

/**
 * turn_towards_x_factor
 * gives veins an upwards curve.
 * 0 makes veins perfectly straight.
 * 1 makes veins curve sharply towards x.
 * careful - high numbers > 0.5 can cause degenerate early vein termination.
 * -1 is an oddity that looks cool but isn't really realistic (veins flowing backwards).
 */
float TURN_TOWARDS_X_FACTOR = 0.1;

/**
 * avoid_neighbor_force
 * tends to spread veins out even if they grow backwards
 * you probably want at least some of this; it gives variety and better texture to the veins
 * 100 is a decent amount
 * This may ruin fragile venation patterns though.
 * you can also go negative which creates these inwards clawing veins. It looks cool, but isn't really realistic.
 * avoid neighbor can help prevent early vein termination from e.g. turn_towards_x_factor.
 */
float AVOID_NEIGHBOR_FORCE = 1;

float randWiggle = 0.0;

/* base_disincentive
 * 0 to 1, 10, 100, and 1000 all produce interesting changes
 * generally speaking, 0 = cordate, 1000 = linear/lanceolate
 */
float BASE_DISINCENTIVE = 0;

/* cost_distance_to_root
 * Failsafe on unbounded growth. Basically leave this around 1e5 to bound the plant at distance ~600.
 */
float COST_DISTANCE_TO_ROOT_DIVISOR = 5e4; // 1e5;
/*
 * cost_negative_x_growth
 * keeps leaves from unboundedly growing backwards.
 * 1e-3 and below basically has no effect.
 * from 1e-3 to 1, the back edge of the leaf shrinks to nothing.
 * You probably want this around 0.2 to 0.5.
 * Around 0.3 you can get cordate shapes with the right combination of parameters.
 */
float COST_NEGATIVE_X_GROWTH = 1;

/**
 * grow_forward_factor
 * basically incentivizes... growing forward. Makes leave ovate.
 * Anything below 10 basically has no effect. 
 * At 100 basically every leaf becomes ovate, and also increases the number of steps taken.
 */
float GROW_FORWARD_FACTOR = 0;

/**
 * max 1,
 * below 0.7 it starts degenerating
 */
float SECONDARY_BRANCH_SCALAR = 1.0;

/**
 * Can help define a more jagged/deeper edge.
 * < -100 = makes things much fatter/more kidney-like. Creates quite complex edges.
 * -100 - 0 = incentivizes curving; creates edges with many fine little details. 
 * 0 - 20 = no effect
 * 20 - 40 = helps make more jagged edges, like maple leaves (but it might be suppressed by other parameters)
 * 40 - 100 = even more jagged edges, but starting to degenerate
 * > 100 = degenerates
 * 
 */
float COST_TO_TURN = 0;

/**
 * You can set this to false and set the sideways angle between PI/6 and PI/12 to get dichotimous veining.
 * This might work for petals.
 */
boolean growForwardBranch = true;