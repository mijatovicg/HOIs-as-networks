function plot_graphs(delta_node, lOIR_link, OIR, fig_name, row, col, pos, nodeNames, min_l, max_l,  x_coor, y_coor, lo)

%% plot
A = lOIR_link;
fig = figure(1); set(fig, 'Visible', 'off');
h = imagesc(A,[min_l max_l]); 
colormap bluewhitered; colorbar;

n = size(A, 1); 
G = graph(); 
G = addnode(G, n); 

% Add the edges to the graph
for i = 1:n
    for j = i+1:n
        if ~isnan(A(i,j))
            G = addedge(G, i, j, A(i,j));
        end
    end
end

ccmap = bluewhitered(256);

%% color-coded egdes
A = lOIR_link;
weights_links = (A - (min_l)) ./ (max_l - (min_l)); 
indices_links = round(weights_links * 255) + 1; 
indices_links(indices_links < 1) = 1;  
indices_links(indices_links > 256) = 256; 

%% color-coded nodes
A = delta_node;

weights_nodes = (A - (min_l)) ./ (max_l - (min_l));
indices_nodes = round(weights_nodes * 255) + 1; 
indices_nodes(indices_nodes < 1) = 1;  
indices_nodes(indices_nodes > 256) = 256;  
%% color-coded network
A = OIR;

weights_net = (A - (min_l)) ./ (max_l - (min_l));
indices_net = round(weights_net * 255) + 1; 
indices_net(indices_net < 1) = 1; 
indices_net(indices_net > 256) = 256;  
%%

figure(fig_name); subplot(row, col, pos);
p = plot(G, 'Layout', lo, 'NodeColor', 'k', 'NodeLabel', {});


if ~isempty(x_coor) & ~isempty(y_coor)
    p.XData = x_coor; 
    p.YData = y_coor; 
end

text(p.XData + 0.2, p.YData, nodeNames, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', 'FontSize', 11, 'FontName', 'Times New Roman');


numNodes = size(G.Nodes,1);
for ii = 1:numNodes
    index_node = indices_nodes(ii);
    color_node = ccmap(index_node, :);
    highlight(p, ii, 'NodeColor', color_node, 'MarkerSize', 9, 'LineWidth', 1.5);
end


edges = G.Edges;
for i = 1:size(edges, 1)
    index_link = indices_links(edges.EndNodes(i,1), edges.EndNodes(i,2));
    color_link = ccmap(index_link, :);
    highlight(p, edges.EndNodes(i,1), edges.EndNodes(i,2), 'EdgeColor', color_link, 'LineWidth', 1.5);
end


index_net = indices_net;
color_net = ccmap(index_net, :);
centerX = 0; centerY = 0; radius = 1.8;   
rectangle('Position', [centerX - radius, centerY - radius, 2*radius, 2*radius],... % Plot circle
    'Curvature', [1, 1], 'EdgeColor', color_net, 'LineWidth', 1.2);


colormap(ccmap); colorbar;
clim([min_l max_l]);
set(gca,'color',0.7*[1 1 1]); 
xticks([]); yticks([]);

