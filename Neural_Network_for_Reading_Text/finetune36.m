%num_epoch = 30;
num_epoch = 5;
classes = 36;
learning_rate = 0.01;

load('../data/nist26_model_60iters.mat', 'W', 'b');
load('../data/nist36_train.mat', 'train_data', 'train_labels')
load('../data/nist36_test.mat', 'test_data', 'test_labels')
load('../data/nist36_valid.mat', 'valid_data', 'valid_labels')

hidden_unit_num = size(W{2},2);
add_weights = -0.1 + (0.2).*rand(10,hidden_unit_num);
add_biases = zeros(10,1);

W{2} = [W{2}; add_weights];
b{2} = [b{2}; add_biases];

W = W';
b = b';

train_acc = zeros(num_epoch,1);
valid_acc = zeros(num_epoch,1);
train_loss = zeros(num_epoch,1);
valid_loss = zeros(num_epoch,1);

for j = 1:num_epoch
    [W, b] = Train(W, b, train_data, train_labels, learning_rate);

    [train_acc(j), train_loss(j)] = ComputeAccuracyAndLoss(W, b, train_data, train_labels);
    [valid_acc(j), valid_loss(j)] = ComputeAccuracyAndLoss(W, b, valid_data, valid_labels);

    fprintf('Epoch %d - accuracy: %.5f, %.5f \t loss: %.5f, %.5f \n', j, train_acc(j), valid_acc(j), train_loss(j), valid_loss(j))
end

figure;
hold on;
xlabel('Number of epochs');
ylabel('Accuracy');
title('Accuracy Vs. Number of epochs');
plt1 = plot(1:num_epoch, train_acc);
plt2 = plot(1:num_epoch, valid_acc);
legend('Training', 'Validation','Location','northwest');
xlim([1 num_epoch])
hold off;
pause(5);

figure;
hold on;
xlabel('Number of epochs');
ylabel('Loss');
title('Loss Vs. Number of epochs');
plt1 = plot(1:num_epoch, train_loss);
plt2 = plot(1:num_epoch, valid_loss);
legend('Training', 'Validation','Location','northwest');
xlim([1 num_epoch])
hold off;

%save('nist36_model.mat', 'W', 'b')
%save('nist36_model_extra.mat', 'train_acc', 'valid_acc', 'train_loss', 'valid_loss')