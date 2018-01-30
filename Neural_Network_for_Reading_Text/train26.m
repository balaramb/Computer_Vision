num_epoch = 30;
classes = 26;
layers = [32*32, 400, classes];
learning_rate = 0.01;

load('../data/nist26_train.mat', 'train_data', 'train_labels')
load('../data/nist26_test.mat', 'test_data', 'test_labels')
load('../data/nist26_valid.mat', 'valid_data', 'valid_labels')

[W, b] = InitializeNetwork(layers);
train_acc = zeros(num_epoch,1);
valid_acc = zeros(num_epoch,1);
train_loss = zeros(num_epoch,1);
valid_loss = zeros(num_epoch,1);

for j = 1:num_epoch
    [W, b] = Train(W, b, train_data, train_labels, learning_rate);

    [train_acc(j,1), train_loss(j,1)] = ComputeAccuracyAndLoss(W, b, train_data, train_labels);
    [valid_acc(j,1), valid_loss(j,1)] = ComputeAccuracyAndLoss(W, b, valid_data, valid_labels);


    fprintf('Epoch %d - accuracy: %.5f, %.5f \t loss: %.5f, %.5f \n', j, train_acc(j,1), valid_acc(j,1), train_loss(j,1), valid_loss(j,1));
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

%save('nist26_model.mat', 'W', 'b')
%save('nist26_model_extra.mat', 'train_acc', 'valid_acc', 'train_loss', 'valid_loss')