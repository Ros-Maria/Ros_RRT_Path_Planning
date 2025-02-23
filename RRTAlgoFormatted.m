% nodes:    Contains list of all explored nodes. Each node contains its
%           coordinates, cost to reach and its parent.
%
% Brief description of first use of RRT* algorithm:
% 1. Pick a random node q_rand.
% 2. Find the closest node q_near from explored nodes to branch out from, towards
%    q_rand.
% 3. Steer from q_near towards q_rand: interpolate if node is too far away, reach
%    q_new. Check that obstacle is not hit.
% 4. Update cost of reaching q_new from q_near, treat it as Cmin. For now,
%    q_near acts as the parent node of q_new.
% 5. From the list of 'visited' nodes, check for nearest neighbors with a
%    given radius, insert in a list q_nearest.
% 6. In all members of q_nearest, check if q_new can be reached from a
%    different parent node with cost lower than Cmin, and without colliding
%    with the obstacle. Select the node that results in the least cost and
%    update the parent of q_new.
% 7. Add q_new to node list.
% 8. Continue until maximum number of nodes is reached or goal is hit.

clearvars
close all

%% variables
% x_max = 100;
% y_max = 100;
% obstacle = [50,20,20,40];
EPS = .1;
numNodes = 100000;
validationDist = 0.01;

%% create the map
%map = circular_occu_map(100,20,[50, 50],[10, 5],[50, 50]);
load exampleMaps.mat
%simpleMap(27,:)=zeros(1,27);
map = occupancyMap(simpleMap,10);

%Creating figure for visualization
% figure(1)
% axis([0 x_max 0 y_max])
% rectangle('Position',obstacle,'FaceColor',[0 .5 .5])
% hold on

%% define S and G & call RRT* function
start = [0.5 0.5 0];
goal = [2.5 0.2 0];

[path, solutionInfo] = planPath(map,start,goal, EPS,numNodes,validationDist);

%% Visualize the results.
map.show
hold on
% Tree expansion
plot(solutionInfo.TreeData(:,1),solutionInfo.TreeData(:,2),'g.-')
% Draw path
plot(path.States(:,1),path.States(:,2),'r-','LineWidth',2)
%disp(path);


%% New obstacle path planning
%newobstacle and co-ordinates
newObstacle = ones(4,6);
simpleMap(8:11,9:14)=newObstacle;
%simpleMap(27,:)=ones(1,27);
mapsize = [size(simpleMap,1),size(simpleMap,2)];
xcentroid =size(newObstacle,1)./2;
ycentroid =size(newObstacle,2)./2;
center =mapsize./2;
radius = max(xcentroid,ycentroid)+4;
rectSize =[2,3];
rectCenter =[7+xcentroid,8+ycentroid];


%% Add new obstacle to the map
map = occupancyMap(simpleMap,10);
%replan the path for new obstacle
[replannedSegment,solutionInfo,si,sj] = replanPathWithNewObstacle(map,path,EPS,numNodes,validationDist);
newPath.States = [path.States(si, :); replannedSegment.States; path.States(sj, :)];
%% plot the path and  map with new 
map.show
hold on
% Tree expansion
plot(solutionInfo.TreeData(:,1),solutionInfo.TreeData(:,2),'g.-')
% Draw path
plot(path.States(:,1),path.States(:,2),'r-','LineWidth',2)
plot(newPath.States(:,1),newPath.States(:,2),'b-','LineWidth',2)

